-- liquibase formatted sql
-- changeset RK_MAIN:1774561691534 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_brm_elem_gefaehrdung_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_brm_elem_gefaehrdung_dml.sql:null:37aae09b491ff9133cee8b696907bfd976275f50:create

create or replace package body rk_main.pck_isr_brm_elem_gefaehrdung_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_brm_elem_gefaehrdung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ege_uid = '
                        || to_char(pir_row.ege_uid)
                        || cv_sep
                        || ', ege_titel = '
                        || pir_row.ege_titel
                        || cv_sep
                        || ', ege_beschreibung = '
                        || pir_row.ege_beschreibung
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
            v_retval := '<table><tr><th>ISR_BRM_ELEM_GEFAEHRDUNG</th><th>Column</th></tr>'
                        || '<tr><td>ege_uid</td><td>'
                        || to_char(pir_row.ege_uid)
                        || '</td></tr>'
                        || '<tr><td>ege_titel</td><td>'
                        || pir_row.ege_titel
                        || '</td></tr>'
                        || '<tr><td>ege_beschreibung</td><td>'
                        || pir_row.ege_beschreibung
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
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_brm_elem_gefaehrdung in out isr_brm_elem_gefaehrdung%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_brm_elem_gefaehrdung.inserted := sysdate;
        pior_isr_brm_elem_gefaehrdung.inserted_by := pck_env.fv_user;
        insert into isr_brm_elem_gefaehrdung values pior_isr_brm_elem_gefaehrdung returning ege_uid into pior_isr_brm_elem_gefaehrdung.ege_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_brm_elem_gefaehrdung! Parameter: ' || fv_print(pir_row => pior_isr_brm_elem_gefaehrdung
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_brm_elem_gefaehrdung in isr_brm_elem_gefaehrdung%rowtype
    ) is
        r_isr_brm_elem_gefaehrdung isr_brm_elem_gefaehrdung%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_brm_elem_gefaehrdung := pir_isr_brm_elem_gefaehrdung;
        r_isr_brm_elem_gefaehrdung.inserted := sysdate;
        r_isr_brm_elem_gefaehrdung.updated := sysdate;
        r_isr_brm_elem_gefaehrdung.inserted_by := pck_env.fv_user;
        r_isr_brm_elem_gefaehrdung.updated_by := pck_env.fv_user;
        merge into isr_brm_elem_gefaehrdung
        using dual on ( ege_uid = r_isr_brm_elem_gefaehrdung.ege_uid )
        when matched then update
        set ege_titel = r_isr_brm_elem_gefaehrdung.ege_titel,
            ege_beschreibung = r_isr_brm_elem_gefaehrdung.ege_beschreibung,
            updated = r_isr_brm_elem_gefaehrdung.updated,
            updated_by = r_isr_brm_elem_gefaehrdung.updated_by,
            aktiv = r_isr_brm_elem_gefaehrdung.aktiv
        when not matched then
        insert (
            ege_titel,
            ege_beschreibung,
            inserted,
            inserted_by,
            aktiv )
        values
            ( r_isr_brm_elem_gefaehrdung.ege_titel,
              r_isr_brm_elem_gefaehrdung.ege_beschreibung,
              r_isr_brm_elem_gefaehrdung.inserted,
              r_isr_brm_elem_gefaehrdung.inserted_by,
              r_isr_brm_elem_gefaehrdung.aktiv );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_brm_elem_gefaehrdung);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_isr_brm_elem_gefaehrdung in isr_brm_elem_gefaehrdung%rowtype,
        piv_art                      in varchar2
    ) is
        r_isr_brm_elem_gefaehrdung isr_brm_elem_gefaehrdung%rowtype;        

-- fuer exceptions        
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_brm_elem_gefaehrdung := pir_isr_brm_elem_gefaehrdung;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_brm_elem_gefaehrdung.inserted,
                    r_isr_brm_elem_gefaehrdung.inserted_by
                from
                    isr_brm_elem_gefaehrdung
                where
                    ege_uid = pir_isr_brm_elem_gefaehrdung.ege_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_brm_elem_gefaehrdung.updated := sysdate;
                r_isr_brm_elem_gefaehrdung.updated_by := pck_env.fv_user;
                update isr_brm_elem_gefaehrdung
                set
                    row = r_isr_brm_elem_gefaehrdung
                where
                    ege_uid = pir_isr_brm_elem_gefaehrdung.ege_uid;

            when '<only_aktiv>' then
                update isr_brm_elem_gefaehrdung
                set
                    updated = sysdate,
                    updated_by = pck_env.fv_user,
                    aktiv = pir_isr_brm_elem_gefaehrdung.aktiv
                where
                    ege_uid = pir_isr_brm_elem_gefaehrdung.ege_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_brm_elem_gefaehrdung);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ege_uid in isr_brm_elem_gefaehrdung.ege_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ege_uid: ' || to_char(pin_ege_uid);
        delete from isr_brm_elem_gefaehrdung
        where
            ege_uid = pin_ege_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_brm_elem_gefaehrdung! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_brm_elem_gefaehrdung! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_brm_elem_gefaehrdung_dml;
/

