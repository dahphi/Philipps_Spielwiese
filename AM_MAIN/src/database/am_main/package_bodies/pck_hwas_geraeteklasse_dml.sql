create or replace package body am_main.pck_hwas_geraeteklasse_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_geraeteklasse%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'gkl_uid = '
                        || to_char(pir_row.gkl_uid)
                        || cv_sep
                        || ', gkl_bezeichnung = '
                        || pir_row.gkl_bezeichnung
                        || cv_sep
                        || ', gkl_highlights = '
                        || pir_row.gkl_highlights
                        || cv_sep
                        || ', gkl_art = '
                        || pir_row.gkl_art
                        || cv_sep
                        || ', tkt_uid = '
                        || to_char(pir_row.tkt_uid)
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
            v_retval := '<table><tr><th>HWAS_GERAETEKLASSE</th><th>Column</th></tr>'
                        || '<tr><td>gkl_uid</td><td>'
                        || to_char(pir_row.gkl_uid)
                        || '</td></tr>'
                        || '<tr><td>gkl_bezeichnung</td><td>'
                        || pir_row.gkl_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>gkl_highlights</td><td>'
                        || pir_row.gkl_highlights
                        || '</td></tr>'
                        || '<tr><td>gkl_art</td><td>'
                        || pir_row.gkl_art
                        || '</td></tr>'
                        || '<tr><td>tkt_uid</td><td>'
                        || to_char(pir_row.tkt_uid)
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
        pior_hwas_geraeteklasse in out hwas_geraeteklasse%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_geraeteklasse.inserted := sysdate;
        pior_hwas_geraeteklasse.inserted_by := pck_env.fv_user;
        insert into hwas_geraeteklasse values pior_hwas_geraeteklasse returning gkl_uid into pior_hwas_geraeteklasse.gkl_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_geraeteklasse! Parameter: ' || fv_print(pir_row => pior_hwas_geraeteklasse
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_geraeteklasse in hwas_geraeteklasse%rowtype
    ) is
        r_hwas_geraeteklasse hwas_geraeteklasse%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_geraeteklasse := pir_hwas_geraeteklasse;
        r_hwas_geraeteklasse.inserted := sysdate;
        r_hwas_geraeteklasse.updated := sysdate;
        r_hwas_geraeteklasse.inserted_by := pck_env.fv_user;
        r_hwas_geraeteklasse.updated_by := pck_env.fv_user;
        merge into hwas_geraeteklasse
        using dual on ( gkl_uid = r_hwas_geraeteklasse.gkl_uid )
        when matched then update
        set gkl_bezeichnung = r_hwas_geraeteklasse.gkl_bezeichnung,
            gkl_highlights = r_hwas_geraeteklasse.gkl_highlights,
            gkl_art = r_hwas_geraeteklasse.gkl_art,
            tkt_uid = r_hwas_geraeteklasse.tkt_uid,
            updated = r_hwas_geraeteklasse.updated,
            updated_by = r_hwas_geraeteklasse.updated_by
        when not matched then
        insert (
            gkl_bezeichnung,
            gkl_highlights,
            gkl_art,
            tkt_uid,
            inserted,
            inserted_by )
        values
            ( r_hwas_geraeteklasse.gkl_bezeichnung,
              r_hwas_geraeteklasse.gkl_highlights,
              r_hwas_geraeteklasse.gkl_art,
              r_hwas_geraeteklasse.tkt_uid,
              r_hwas_geraeteklasse.inserted,
              r_hwas_geraeteklasse.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_geraeteklasse);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_geraeteklasse in hwas_geraeteklasse%rowtype,
        piv_art                in varchar2
    ) is
        r_hwas_geraeteklasse hwas_geraeteklasse%rowtype;        

-- fuer exceptions        
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_geraeteklasse := pir_hwas_geraeteklasse;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_geraeteklasse.inserted,
                    r_hwas_geraeteklasse.inserted_by
                from
                    hwas_geraeteklasse
                where
                    gkl_uid = pir_hwas_geraeteklasse.gkl_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_geraeteklasse.updated := sysdate;
                r_hwas_geraeteklasse.updated_by := pck_env.fv_user;
                update hwas_geraeteklasse
                set
                    row = r_hwas_geraeteklasse
                where
                    gkl_uid = pir_hwas_geraeteklasse.gkl_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_geraeteklasse);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_gkl_uid in hwas_geraeteklasse.gkl_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_gkl_uid: ' || to_char(pin_gkl_uid);
        delete from hwas_geraeteklasse
        where
            gkl_uid = pin_gkl_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_geraeteklasse! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_geraeteklasse! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_geraeteklasse_dml;
/


-- sqlcl_snapshot {"hash":"db3429a0743d7056cf0b843ffdf949762e055966","type":"PACKAGE_BODY","name":"PCK_HWAS_GERAETEKLASSE_DML","schemaName":"AM_MAIN","sxml":""}