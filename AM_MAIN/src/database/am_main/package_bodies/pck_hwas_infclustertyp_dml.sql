create or replace package body am_main.pck_hwas_infclustertyp_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_infclustertyp%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ICT_UID = '
                        || to_char(pir_row.ict_uid)
                        || cv_sep
                        || ', TYP = '
                        || pir_row.typ
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
            v_retval := '<table><tr><th>HWAS_INFCLUSTERTYP</th><th>Column</th></tr>'
                        || '<tr><td>ICT_UID</td><td>'
                        || to_char(pir_row.ict_uid)
                        || '</td></tr>'
                        || '<tr><td>TYP</td><td>'
                        || pir_row.typ
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
        pior_hwas_infclustertyp in out hwas_infclustertyp%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_infclustertyp.inserted := sysdate;
        pior_hwas_infclustertyp.inserted_by := pck_env.fv_user;
        insert into hwas_infclustertyp values pior_hwas_infclustertyp returning ict_uid into pior_hwas_infclustertyp.ict_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle HWAS_INFCLUSTERTYP! Parameter: ' || fv_print(pir_row => pior_hwas_infclustertyp
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_infclustertyp in hwas_infclustertyp%rowtype
    ) is
        r_hwas_infclustertyp hwas_infclustertyp%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_infclustertyp := pir_hwas_infclustertyp;
        r_hwas_infclustertyp.inserted := sysdate;
        r_hwas_infclustertyp.updated := sysdate;
        r_hwas_infclustertyp.inserted_by := pck_env.fv_user;
        r_hwas_infclustertyp.updated_by := pck_env.fv_user;
        merge into hwas_infclustertyp
        using dual on ( ict_uid = r_hwas_infclustertyp.ict_uid )
        when matched then update
        set typ = r_hwas_infclustertyp.typ,
            beschreibung = r_hwas_infclustertyp.beschreibung,
            updated = r_hwas_infclustertyp.updated,
            updated_by = r_hwas_infclustertyp.updated_by
        when not matched then
        insert (
            typ,
            beschreibung,
            inserted,
            inserted_by )
        values
            ( r_hwas_infclustertyp.typ,
              r_hwas_infclustertyp.beschreibung,
              r_hwas_infclustertyp.inserted,
              r_hwas_infclustertyp.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_infclustertyp);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_infclustertyp in hwas_infclustertyp%rowtype,
        piv_art                in varchar2
    ) is
        r_hwas_infclustertyp hwas_infclustertyp%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_infclustertyp.typ := pir_hwas_infclustertyp.typ;
        r_hwas_infclustertyp.beschreibung := pir_hwas_infclustertyp.beschreibung;
        r_hwas_infclustertyp.updated := sysdate;
        r_hwas_infclustertyp.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update hwas_infclustertyp
                set
                    ict_uid = pir_hwas_infclustertyp.ict_uid
                where
                    ict_uid = pir_hwas_infclustertyp.ict_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_infclustertyp := pir_hwas_infclustertyp;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_infclustertyp.inserted,
                    r_hwas_infclustertyp.inserted_by
                from
                    hwas_infclustertyp
                where
                    ict_uid = pir_hwas_infclustertyp.ict_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_infclustertyp.updated := sysdate;
                r_hwas_infclustertyp.updated_by := pck_env.fv_user;
                update hwas_infclustertyp
                set
                    row = r_hwas_infclustertyp
                where
                    ict_uid = pir_hwas_infclustertyp.ict_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_infclustertyp);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ict_uid in hwas_infclustertyp.ict_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ICT_UID: ' || to_char(pin_ict_uid);
        delete from hwas_infclustertyp
        where
            ict_uid = pin_ict_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle HWAS_INFCLUSTERTYP! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle HWAS_INFCLUSTERTYP! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_infclustertyp_dml;
/


-- sqlcl_snapshot {"hash":"3b525804288cd40a253e02f20b835e8c7100bee2","type":"PACKAGE_BODY","name":"PCK_HWAS_INFCLUSTERTYP_DML","schemaName":"AM_MAIN","sxml":""}