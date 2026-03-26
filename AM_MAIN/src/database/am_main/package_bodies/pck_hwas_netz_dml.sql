create or replace package body am_main.pck_hwas_netz_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_netz%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'net_uid = '
                        || to_char(pir_row.net_uid)
                        || cv_sep
                        || ', net_bezeichnung = '
                        || pir_row.net_bezeichnung
                        || cv_sep
                        || ', net_beschreibung = '
                        || pir_row.net_beschreibung
                        || cv_sep
                        || ', ak3_uid = '
                        || to_char(pir_row.ak3_uid)
                        || cv_sep
                        || ', tkt_uid = '
                        || to_char(pir_row.tkt_uid)
                        || cv_sep
                        || ', ad_san_anspechpartner = '
                        || pir_row.ad_san_anspechpartner
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
            v_retval := '<table><tr><th>HWAS_NETZ</th><th>Column</th></tr>'
                        || '<tr><td>net_uid</td><td>'
                        || to_char(pir_row.net_uid)
                        || '</td></tr>'
                        || '<tr><td>net_bezeichnung</td><td>'
                        || pir_row.net_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>net_beschreibung</td><td>'
                        || pir_row.net_beschreibung
                        || '</td></tr>'
                        || '<tr><td>ak3_uid</td><td>'
                        || to_char(pir_row.ak3_uid)
                        || '</td></tr>'
                        || '<tr><td>tkt_uid</td><td>'
                        || to_char(pir_row.tkt_uid)
                        || '</td></tr>'
                        || '<tr><td>ad_san_anspechpartner</td><td>'
                        || pir_row.ad_san_anspechpartner
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
        pior_hwas_netz in out hwas_netz%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_netz.inserted := sysdate;
        pior_hwas_netz.inserted_by := pck_env.fv_user;
        insert into hwas_netz values pior_hwas_netz returning net_uid into pior_hwas_netz.net_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_netz! Parameter: ' || fv_print(pir_row => pior_hwas_netz);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_netz in hwas_netz%rowtype
    ) is
        r_hwas_netz    hwas_netz%rowtype;

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_netz := pir_hwas_netz;
        r_hwas_netz.inserted := sysdate;
        r_hwas_netz.updated := sysdate;
        r_hwas_netz.inserted_by := pck_env.fv_user;
        r_hwas_netz.updated_by := pck_env.fv_user;
        merge into hwas_netz
        using dual on ( net_uid = r_hwas_netz.net_uid )
        when matched then update
        set net_bezeichnung = r_hwas_netz.net_bezeichnung,
            net_beschreibung = r_hwas_netz.net_beschreibung,
            ak3_uid = r_hwas_netz.ak3_uid,
            tkt_uid = r_hwas_netz.tkt_uid,
            ad_san_anspechpartner = r_hwas_netz.ad_san_anspechpartner,
            updated = r_hwas_netz.updated,
            updated_by = r_hwas_netz.updated_by
        when not matched then
        insert (
            net_bezeichnung,
            net_beschreibung,
            ak3_uid,
            tkt_uid,
            ad_san_anspechpartner,
            inserted,
            inserted_by )
        values
            ( r_hwas_netz.net_bezeichnung,
              r_hwas_netz.net_beschreibung,
              r_hwas_netz.ak3_uid,
              r_hwas_netz.tkt_uid,
              r_hwas_netz.ad_san_anspechpartner,
              r_hwas_netz.inserted,
              r_hwas_netz.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_netz);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_netz in hwas_netz%rowtype,
        piv_art       in varchar2
    ) is
        r_hwas_netz    hwas_netz%rowtype;        

-- fuer exceptions        
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_netz := pir_hwas_netz;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_netz.inserted,
                    r_hwas_netz.inserted_by
                from
                    hwas_netz
                where
                    net_uid = pir_hwas_netz.net_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_netz.updated := sysdate;
                r_hwas_netz.updated_by := pck_env.fv_user;
                update hwas_netz
                set
                    row = r_hwas_netz
                where
                    net_uid = pir_hwas_netz.net_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_netz);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_net_uid in hwas_netz.net_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_net_uid: ' || to_char(pin_net_uid);
        delete from hwas_netz
        where
            net_uid = pin_net_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_netz! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_netz! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_netz_dml;
/


-- sqlcl_snapshot {"hash":"213a77d5ca90775cde4fd38f79a70676907786ca","type":"PACKAGE_BODY","name":"PCK_HWAS_NETZ_DML","schemaName":"AM_MAIN","sxml":""}