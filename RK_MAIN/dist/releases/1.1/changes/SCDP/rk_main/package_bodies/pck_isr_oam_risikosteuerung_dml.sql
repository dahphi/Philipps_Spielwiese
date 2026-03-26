-- liquibase formatted sql
-- changeset RK_MAIN:1774555712162 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_oam_risikosteuerung_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_oam_risikosteuerung_dml.sql:null:b0f5a57cde1e288e0ad7e57b24c6c4b1f2ab912b:create

create or replace package body rk_main.pck_isr_oam_risikosteuerung_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_risikosteuerung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ris_uid = '
                        || to_char(pir_row.ris_uid)
                        || cv_sep
                        || ', ris_titel = '
                        || pir_row.ris_titel
                        || cv_sep
                        || ', ris_beschreibung = '
                        || pir_row.ris_beschreibung
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
                        || ', aktiv = '
                        || to_char(pir_row.aktiv)
                        || cv_sep
                        || ', ris_akzeptanz = '
                        || to_char(pir_row.ris_akzeptanz)
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
            v_retval := '<table><tr><th>ISR_OAM_RISIKOSTEUERUNG</th><th>Column</th></tr>'
                        || '<tr><td>ris_uid</td><td>'
                        || to_char(pir_row.ris_uid)
                        || '</td></tr>'
                        || '<tr><td>ris_titel</td><td>'
                        || pir_row.ris_titel
                        || '</td></tr>'
                        || '<tr><td>ris_beschreibung</td><td>'
                        || pir_row.ris_beschreibung
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
                        || '<tr><td>aktiv</td><td>'
                        || to_char(pir_row.aktiv)
                        || '</td></tr>'
                        || '<tr><td>ris_akzeptanz</td><td>'
                        || to_char(pir_row.ris_akzeptanz)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_risikosteuerung in out isr_oam_risikosteuerung%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_risikosteuerung.inserted := sysdate;
        pior_isr_oam_risikosteuerung.inserted_by := pck_env.fv_user;
        insert into isr_oam_risikosteuerung values pior_isr_oam_risikosteuerung returning ris_uid into pior_isr_oam_risikosteuerung.ris_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_risikosteuerung! Parameter: ' || fv_print(pir_row => pior_isr_oam_risikosteuerung
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_risikosteuerung in isr_oam_risikosteuerung%rowtype
    ) is
        r_isr_oam_risikosteuerung isr_oam_risikosteuerung%rowtype;

  -- fuer exceptions
        v_routine_name            logs.routine_name%type;
        c_message                 clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_risikosteuerung := pir_isr_oam_risikosteuerung;
        r_isr_oam_risikosteuerung.inserted := sysdate;
        r_isr_oam_risikosteuerung.updated := sysdate;
        r_isr_oam_risikosteuerung.inserted_by := pck_env.fv_user;
        r_isr_oam_risikosteuerung.updated_by := pck_env.fv_user;
        merge into isr_oam_risikosteuerung
        using dual on ( ris_uid = r_isr_oam_risikosteuerung.ris_uid )
        when matched then update
        set ris_titel = r_isr_oam_risikosteuerung.ris_titel,
            ris_beschreibung = r_isr_oam_risikosteuerung.ris_beschreibung,
            updated = r_isr_oam_risikosteuerung.updated,
            updated_by = r_isr_oam_risikosteuerung.updated_by,
            aktiv = r_isr_oam_risikosteuerung.aktiv,
            ris_akzeptanz = r_isr_oam_risikosteuerung.ris_akzeptanz
        when not matched then
        insert (
            ris_titel,
            ris_beschreibung,
            inserted,
            inserted_by,
            aktiv,
            ris_akzeptanz )
        values
            ( r_isr_oam_risikosteuerung.ris_titel,
              r_isr_oam_risikosteuerung.ris_beschreibung,
              r_isr_oam_risikosteuerung.inserted,
              r_isr_oam_risikosteuerung.inserted_by,
              r_isr_oam_risikosteuerung.aktiv,
              r_isr_oam_risikosteuerung.ris_akzeptanz );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_risikosteuerung);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_oam_risikosteuerung in isr_oam_risikosteuerung%rowtype,
        piv_art                     in varchar2
    ) is
        r_isr_oam_risikosteuerung isr_oam_risikosteuerung%rowtype;

  -- fuer exceptions
        v_routine_name            logs.routine_name%type;
        c_message                 clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_oam_risikosteuerung.ris_titel := pir_isr_oam_risikosteuerung.ris_titel;
        r_isr_oam_risikosteuerung.ris_beschreibung := pir_isr_oam_risikosteuerung.ris_beschreibung;
        r_isr_oam_risikosteuerung.updated := sysdate;
        r_isr_oam_risikosteuerung.updated_by := pck_env.fv_user;
        r_isr_oam_risikosteuerung.aktiv := pir_isr_oam_risikosteuerung.aktiv;
        r_isr_oam_risikosteuerung.ris_akzeptanz := pir_isr_oam_risikosteuerung.ris_akzeptanz;
        case piv_art
            when '<replace>' then
                update isr_oam_risikosteuerung
                set
                    ris_uid = pir_isr_oam_risikosteuerung.ris_uid
                where
                    ris_uid = pir_isr_oam_risikosteuerung.ris_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_oam_risikosteuerung := pir_isr_oam_risikosteuerung;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_risikosteuerung.inserted,
                    r_isr_oam_risikosteuerung.inserted_by
                from
                    isr_oam_risikosteuerung
                where
                    ris_uid = pir_isr_oam_risikosteuerung.ris_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_oam_risikosteuerung.updated := sysdate;
                r_isr_oam_risikosteuerung.updated_by := pck_env.fv_user;
                update isr_oam_risikosteuerung
                set
                    row = r_isr_oam_risikosteuerung
                where
                    ris_uid = pir_isr_oam_risikosteuerung.ris_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_risikosteuerung);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ris_uid in isr_oam_risikosteuerung.ris_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ris_uid: ' || to_char(pin_ris_uid);
        delete from isr_oam_risikosteuerung
        where
            ris_uid = pin_ris_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_risikosteuerung! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_risikosteuerung! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_oam_risikosteuerung_dml;
/

