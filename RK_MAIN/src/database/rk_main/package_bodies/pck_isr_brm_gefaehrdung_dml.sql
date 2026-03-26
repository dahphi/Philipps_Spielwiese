create or replace package body rk_main.pck_isr_brm_gefaehrdung_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_brm_gefaehrdung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'gef_uid = '
                        || to_char(pir_row.gef_uid)
                        || cv_sep
                        || ', gef_titel = '
                        || pir_row.gef_titel
                        || cv_sep
                        || ', gef_beschreibung = '
                        || pir_row.gef_beschreibung
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
                        || ', gef_aut_betroffen = '
                        || to_char(pir_row.gef_aut_betroffen)
                        || cv_sep
                        || ', gef_int_betroffen = '
                        || to_char(pir_row.gef_int_betroffen)
                        || cv_sep
                        || ', gef_vef_betroffen = '
                        || to_char(pir_row.gef_vef_betroffen)
                        || cv_sep
                        || ', gef_vet_betroffen = '
                        || to_char(pir_row.gef_vet_betroffen)
                        || cv_sep
                        || ', gfk_uid = '
                        || to_char(pir_row.gfk_uid)
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
            v_retval := '<table><tr><th>ISR_BRM_GEFAEHRDUNG</th><th>Column</th></tr>'
                        || '<tr><td>gef_uid</td><td>'
                        || to_char(pir_row.gef_uid)
                        || '</td></tr>'
                        || '<tr><td>gef_titel</td><td>'
                        || pir_row.gef_titel
                        || '</td></tr>'
                        || '<tr><td>gef_beschreibung</td><td>'
                        || pir_row.gef_beschreibung
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
                        || '<tr><td>gef_aut_betroffen</td><td>'
                        || to_char(pir_row.gef_aut_betroffen)
                        || '</td></tr>'
                        || '<tr><td>gef_int_betroffen</td><td>'
                        || to_char(pir_row.gef_int_betroffen)
                        || '</td></tr>'
                        || '<tr><td>gef_vef_betroffen</td><td>'
                        || to_char(pir_row.gef_vef_betroffen)
                        || '</td></tr>'
                        || '<tr><td>gef_vet_betroffen</td><td>'
                        || to_char(pir_row.gef_vet_betroffen)
                        || '</td></tr>'
                        || '<tr><td>gfk_uid</td><td>'
                        || to_char(pir_row.gfk_uid)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_brm_gefaehrdung in out isr_brm_gefaehrdung%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_brm_gefaehrdung.inserted := sysdate;
        pior_isr_brm_gefaehrdung.inserted_by := pck_env.fv_user;
        insert into isr_brm_gefaehrdung values pior_isr_brm_gefaehrdung returning gef_uid into pior_isr_brm_gefaehrdung.gef_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_brm_gefaehrdung! Parameter: ' || fv_print(pir_row => pior_isr_brm_gefaehrdung
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_brm_gefaehrdung in isr_brm_gefaehrdung%rowtype
    ) is
        r_isr_brm_gefaehrdung isr_brm_gefaehrdung%rowtype;

  -- fuer exceptions
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_brm_gefaehrdung := pir_isr_brm_gefaehrdung;
        r_isr_brm_gefaehrdung.inserted := sysdate;
        r_isr_brm_gefaehrdung.updated := sysdate;
        r_isr_brm_gefaehrdung.inserted_by := pck_env.fv_user;
        r_isr_brm_gefaehrdung.updated_by := pck_env.fv_user;
        merge into isr_brm_gefaehrdung
        using dual on ( gef_uid = r_isr_brm_gefaehrdung.gef_uid )
        when matched then update
        set gef_titel = r_isr_brm_gefaehrdung.gef_titel,
            gef_beschreibung = r_isr_brm_gefaehrdung.gef_beschreibung,
            updated = r_isr_brm_gefaehrdung.updated,
            updated_by = r_isr_brm_gefaehrdung.updated_by,
            aktiv = r_isr_brm_gefaehrdung.aktiv,
            gef_aut_betroffen = r_isr_brm_gefaehrdung.gef_aut_betroffen,
            gef_int_betroffen = r_isr_brm_gefaehrdung.gef_int_betroffen,
            gef_vef_betroffen = r_isr_brm_gefaehrdung.gef_vef_betroffen,
            gef_vet_betroffen = r_isr_brm_gefaehrdung.gef_vet_betroffen,
            gfk_uid = r_isr_brm_gefaehrdung.gfk_uid
        when not matched then
        insert (
            gef_titel,
            gef_beschreibung,
            inserted,
            inserted_by,
            aktiv,
            gef_aut_betroffen,
            gef_int_betroffen,
            gef_vef_betroffen,
            gef_vet_betroffen,
            gfk_uid )
        values
            ( r_isr_brm_gefaehrdung.gef_titel,
              r_isr_brm_gefaehrdung.gef_beschreibung,
              r_isr_brm_gefaehrdung.inserted,
              r_isr_brm_gefaehrdung.inserted_by,
              r_isr_brm_gefaehrdung.aktiv,
              r_isr_brm_gefaehrdung.gef_aut_betroffen,
              r_isr_brm_gefaehrdung.gef_int_betroffen,
              r_isr_brm_gefaehrdung.gef_vef_betroffen,
              r_isr_brm_gefaehrdung.gef_vet_betroffen,
              r_isr_brm_gefaehrdung.gfk_uid );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_brm_gefaehrdung);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_brm_gefaehrdung in isr_brm_gefaehrdung%rowtype,
        piv_art                 in varchar2
    ) is
        r_isr_brm_gefaehrdung isr_brm_gefaehrdung%rowtype;

  -- fuer exceptions
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_brm_gefaehrdung.gef_titel := pir_isr_brm_gefaehrdung.gef_titel;
        r_isr_brm_gefaehrdung.gef_beschreibung := pir_isr_brm_gefaehrdung.gef_beschreibung;
        r_isr_brm_gefaehrdung.updated := sysdate;
        r_isr_brm_gefaehrdung.updated_by := pck_env.fv_user;
        r_isr_brm_gefaehrdung.aktiv := pir_isr_brm_gefaehrdung.aktiv;
        r_isr_brm_gefaehrdung.gef_aut_betroffen := pir_isr_brm_gefaehrdung.gef_aut_betroffen;
        r_isr_brm_gefaehrdung.gef_int_betroffen := pir_isr_brm_gefaehrdung.gef_int_betroffen;
        r_isr_brm_gefaehrdung.gef_vef_betroffen := pir_isr_brm_gefaehrdung.gef_vef_betroffen;
        r_isr_brm_gefaehrdung.gef_vet_betroffen := pir_isr_brm_gefaehrdung.gef_vet_betroffen;
        r_isr_brm_gefaehrdung.gfk_uid := pir_isr_brm_gefaehrdung.gfk_uid;
        case piv_art
            when '<replace>' then
                update isr_brm_gefaehrdung
                set
                    gef_uid = pir_isr_brm_gefaehrdung.gef_uid
                where
                    gef_uid = pir_isr_brm_gefaehrdung.gef_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_brm_gefaehrdung := pir_isr_brm_gefaehrdung;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_brm_gefaehrdung.inserted,
                    r_isr_brm_gefaehrdung.inserted_by
                from
                    isr_brm_gefaehrdung
                where
                    gef_uid = pir_isr_brm_gefaehrdung.gef_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_brm_gefaehrdung.updated := sysdate;
                r_isr_brm_gefaehrdung.updated_by := pck_env.fv_user;
                update isr_brm_gefaehrdung
                set
                    row = r_isr_brm_gefaehrdung
                where
                    gef_uid = pir_isr_brm_gefaehrdung.gef_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_brm_gefaehrdung);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_gef_uid in isr_brm_gefaehrdung.gef_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_gef_uid: ' || to_char(pin_gef_uid);
        delete from isr_brm_gefaehrdung
        where
            gef_uid = pin_gef_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_brm_gefaehrdung! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_brm_gefaehrdung! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_brm_gefaehrdung_dml;
/


-- sqlcl_snapshot {"hash":"737a86561760f78246e15a73ec1a774e3a507330","type":"PACKAGE_BODY","name":"PCK_ISR_BRM_GEFAEHRDUNG_DML","schemaName":"RK_MAIN","sxml":""}