-- liquibase formatted sql
-- changeset RK_MAIN:1774555710680 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_iso_27001_kapitel_a_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_iso_27001_kapitel_a_dml.sql:null:b1e293caddfa93c570bb0cbf7a22f486a7026b7c:create

create or replace package body rk_main.pck_isr_iso_27001_kapitel_a_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_iso_27001_kapitel_a%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'KAP_UID = '
                        || to_char(pir_row.kap_uid)
                        || cv_sep
                        || ', KAPITEL = '
                        || pir_row.kapitel
                        || cv_sep
                        || ', KAPITEL_BESCHREIBUNG = '
                        || pir_row.kapitel_beschreibung
                        || cv_sep
                        || ', KAPITEL_JAHR = '
                        || pir_row.kapitel_jahr
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
            v_retval := '<table><tr><th>ISR_ISO_27001_KAPITEL_A</th><th>Column</th></tr>'
                        || '<tr><td>KAP_UID</td><td>'
                        || to_char(pir_row.kap_uid)
                        || '</td></tr>'
                        || '<tr><td>KAPITEL</td><td>'
                        || pir_row.kapitel
                        || '</td></tr>'
                        || '<tr><td>KAPITEL_BESCHREIBUNG</td><td>'
                        || pir_row.kapitel_beschreibung
                        || '</td></tr>'
                        || '<tr><td>KAPITEL_JAHR</td><td>'
                        || pir_row.kapitel_jahr
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
        pior_isr_iso_27001_kapitel_a in out isr_iso_27001_kapitel_a%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_iso_27001_kapitel_a.inserted := sysdate;
        pior_isr_iso_27001_kapitel_a.inserted_by := pck_env.fv_user;
        insert into isr_iso_27001_kapitel_a values pior_isr_iso_27001_kapitel_a returning kap_uid into pior_isr_iso_27001_kapitel_a.kap_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle ISR_ISO_27001_KAPITEL_A! Parameter: ' || fv_print(pir_row => pior_isr_iso_27001_kapitel_a
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_iso_27001_kapitel_a in isr_iso_27001_kapitel_a%rowtype
    ) is
        r_isr_iso_27001_kapitel_a isr_iso_27001_kapitel_a%rowtype;

  -- fuer exceptions
        v_routine_name            logs.routine_name%type;
        c_message                 clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_iso_27001_kapitel_a := pir_isr_iso_27001_kapitel_a;
        r_isr_iso_27001_kapitel_a.inserted := sysdate;
        r_isr_iso_27001_kapitel_a.updated := sysdate;
        r_isr_iso_27001_kapitel_a.inserted_by := pck_env.fv_user;
        r_isr_iso_27001_kapitel_a.updated_by := pck_env.fv_user;
        merge into isr_iso_27001_kapitel_a
        using dual on ( kap_uid = r_isr_iso_27001_kapitel_a.kap_uid )
        when matched then update
        set kapitel = r_isr_iso_27001_kapitel_a.kapitel,
            kapitel_beschreibung = r_isr_iso_27001_kapitel_a.kapitel_beschreibung,
            kapitel_jahr = r_isr_iso_27001_kapitel_a.kapitel_jahr,
            updated = r_isr_iso_27001_kapitel_a.updated,
            updated_by = r_isr_iso_27001_kapitel_a.updated_by
        when not matched then
        insert (
            kapitel,
            kapitel_beschreibung,
            kapitel_jahr,
            inserted,
            inserted_by )
        values
            ( r_isr_iso_27001_kapitel_a.kapitel,
              r_isr_iso_27001_kapitel_a.kapitel_beschreibung,
              r_isr_iso_27001_kapitel_a.kapitel_jahr,
              r_isr_iso_27001_kapitel_a.inserted,
              r_isr_iso_27001_kapitel_a.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_iso_27001_kapitel_a);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_iso_27001_kapitel_a in isr_iso_27001_kapitel_a%rowtype,
        piv_art                     in varchar2
    ) is
        r_isr_iso_27001_kapitel_a isr_iso_27001_kapitel_a%rowtype;

  -- fuer exceptions
        v_routine_name            logs.routine_name%type;
        c_message                 clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_iso_27001_kapitel_a.kapitel := pir_isr_iso_27001_kapitel_a.kapitel;
        r_isr_iso_27001_kapitel_a.kapitel_beschreibung := pir_isr_iso_27001_kapitel_a.kapitel_beschreibung;
        r_isr_iso_27001_kapitel_a.kapitel_jahr := pir_isr_iso_27001_kapitel_a.kapitel_jahr;
        r_isr_iso_27001_kapitel_a.updated := sysdate;
        r_isr_iso_27001_kapitel_a.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update isr_iso_27001_kapitel_a
                set
                    kap_uid = pir_isr_iso_27001_kapitel_a.kap_uid
                where
                    kap_uid = pir_isr_iso_27001_kapitel_a.kap_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_iso_27001_kapitel_a := pir_isr_iso_27001_kapitel_a;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_iso_27001_kapitel_a.inserted,
                    r_isr_iso_27001_kapitel_a.inserted_by
                from
                    isr_iso_27001_kapitel_a
                where
                    kap_uid = pir_isr_iso_27001_kapitel_a.kap_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_iso_27001_kapitel_a.updated := sysdate;
                r_isr_iso_27001_kapitel_a.updated_by := pck_env.fv_user;
                update isr_iso_27001_kapitel_a
                set
                    row = r_isr_iso_27001_kapitel_a
                where
                    kap_uid = pir_isr_iso_27001_kapitel_a.kap_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_iso_27001_kapitel_a);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_kap_uid in isr_iso_27001_kapitel_a.kap_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_KAP_UID: ' || to_char(pin_kap_uid);
        delete from isr_iso_27001_kapitel_a
        where
            kap_uid = pin_kap_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle ISR_ISO_27001_KAPITEL_A! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle ISR_ISO_27001_KAPITEL_A! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_iso_27001_kapitel_a_dml;
/

