create or replace package body awh_main.pck_awh_schutz_integritaet_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in awh_tab_schutz_integritaet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'INT_LFD_NR = '
                        || to_char(pir_row.int_lfd_nr)
                        || cv_sep
                        || ', INT_BEDEUTUNG = '
                        || pir_row.int_bedeutung
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
            v_retval := '<table><tr><th>AWH_TAB_SCHUTZ_INTEGRITAET</th><th>Column</th></tr>'
                        || '<tr><td>INT_LFD_NR</td><td>'
                        || to_char(pir_row.int_lfd_nr)
                        || '</td></tr>'
                        || '<tr><td>INT_BEDEUTUNG</td><td>'
                        || pir_row.int_bedeutung
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
        pior_schutz_integritaet in out awh_tab_schutz_integritaet%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_schutz_integritaet.inserted := sysdate;
        pior_schutz_integritaet.inserted_by := pck_env.fv_user;
        insert into awh_tab_schutz_integritaet values pior_schutz_integritaet returning int_lfd_nr into pior_schutz_integritaet.int_lfd_nr
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle AWH_TAB_SCHUTZ_INTEGRITAET! Parameter: ' || fv_print(pir_row => pior_schutz_integritaet
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_schutz_integritaet in awh_tab_schutz_integritaet%rowtype
    ) is
        r_schutz_integritaet awh_tab_schutz_integritaet%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_schutz_integritaet := pir_schutz_integritaet;
        r_schutz_integritaet.inserted := sysdate;
        r_schutz_integritaet.updated := sysdate;
        r_schutz_integritaet.inserted_by := pck_env.fv_user;
        r_schutz_integritaet.updated_by := pck_env.fv_user;
        merge into awh_tab_schutz_integritaet
        using dual on ( int_lfd_nr = r_schutz_integritaet.int_lfd_nr )
        when matched then update
        set int_bedeutung = r_schutz_integritaet.int_bedeutung,
            updated = r_schutz_integritaet.updated,
            updated_by = r_schutz_integritaet.updated_by
        when not matched then
        insert (
            int_bedeutung,
            inserted,
            inserted_by )
        values
            ( r_schutz_integritaet.int_bedeutung,
              r_schutz_integritaet.inserted,
              r_schutz_integritaet.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_schutz_integritaet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_schutz_integritaet in awh_tab_schutz_integritaet%rowtype,
        piv_art                in varchar2
    ) is
        r_schutz_integritaet awh_tab_schutz_integritaet%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_schutz_integritaet.int_bedeutung := pir_schutz_integritaet.int_bedeutung;
        r_schutz_integritaet.updated := sysdate;
        r_schutz_integritaet.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update awh_tab_schutz_integritaet
                set
                    int_lfd_nr = pir_schutz_integritaet.int_lfd_nr
                where
                    int_lfd_nr = pir_schutz_integritaet.int_lfd_nr;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_schutz_integritaet := pir_schutz_integritaet;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_schutz_integritaet.inserted,
                    r_schutz_integritaet.inserted_by
                from
                    awh_tab_schutz_integritaet
                where
                    int_lfd_nr = pir_schutz_integritaet.int_lfd_nr;  
      -- Ergänzen der Update-Daten  
                r_schutz_integritaet.updated := sysdate;
                r_schutz_integritaet.updated_by := pck_env.fv_user;
                update awh_tab_schutz_integritaet
                set
                    row = r_schutz_integritaet
                where
                    int_lfd_nr = pir_schutz_integritaet.int_lfd_nr;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_schutz_integritaet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_int_lfd_nr in awh_tab_schutz_integritaet.int_lfd_nr%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_INT_LFD_NR: ' || to_char(pin_int_lfd_nr);
        delete from awh_tab_schutz_integritaet
        where
            int_lfd_nr = pin_int_lfd_nr;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle AWH_TAB_SCHUTZ_INTEGRITAET! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle AWH_TAB_SCHUTZ_INTEGRITAET! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_awh_schutz_integritaet_dml;
/


-- sqlcl_snapshot {"hash":"86e1a8d66f0ccb29f39322de92506a6cad4c8f19","type":"PACKAGE_BODY","name":"PCK_AWH_SCHUTZ_INTEGRITAET_DML","schemaName":"AWH_MAIN","sxml":""}