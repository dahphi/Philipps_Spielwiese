-- liquibase formatted sql
-- changeset AM_MAIN:1774556569561 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_geraeteverbund_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_geraeteverbund_dml.sql:null:7c753ea365358fd24ab8ddd8cd4f368ebd572701:create

create or replace package body am_main.pck_hwas_geraeteverbund_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_geraeteverbund%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'gvb_uid = '
                        || to_char(pir_row.gvb_uid)
                        || cv_sep
                        || ', gvb_bezeichnung = '
                        || pir_row.gvb_bezeichnung
                        || cv_sep
                        || ', gvb_san = '
                        || pir_row.gvb_san
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
                        || ', gvb_verbundtyp = '
                        || pir_row.gvb_verbundtyp
                        || cv_sep
                        || ', typ_uid = '
                        || to_char(pir_row.typ_uid)
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
            v_retval := '<table><tr><th>HWAS_GERAETEVERBUND</th><th>Column</th></tr>'
                        || '<tr><td>gvb_uid</td><td>'
                        || to_char(pir_row.gvb_uid)
                        || '</td></tr>'
                        || '<tr><td>gvb_bezeichnung</td><td>'
                        || pir_row.gvb_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>gvb_san</td><td>'
                        || pir_row.gvb_san
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
                        || '<tr><td>gvb_verbundtyp</td><td>'
                        || pir_row.gvb_verbundtyp
                        || '</td></tr>'
                        || '<tr><td>typ_uid</td><td>'
                        || to_char(pir_row.typ_uid)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_geraeteverbund in out hwas_geraeteverbund%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_geraeteverbund.inserted := sysdate;
        pior_hwas_geraeteverbund.inserted_by := pck_env.fv_user;
        insert into hwas_geraeteverbund values pior_hwas_geraeteverbund returning gvb_uid into pior_hwas_geraeteverbund.gvb_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_geraeteverbund! Parameter: ' || fv_print(pir_row => pior_hwas_geraeteverbund
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_geraeteverbund in hwas_geraeteverbund%rowtype
    ) is
        r_hwas_geraeteverbund hwas_geraeteverbund%rowtype;

  -- fuer exceptions
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_geraeteverbund := pir_hwas_geraeteverbund;
        r_hwas_geraeteverbund.inserted := sysdate;
        r_hwas_geraeteverbund.updated := sysdate;
        r_hwas_geraeteverbund.inserted_by := pck_env.fv_user;
        r_hwas_geraeteverbund.updated_by := pck_env.fv_user;
        merge into hwas_geraeteverbund
        using dual on ( gvb_uid = r_hwas_geraeteverbund.gvb_uid )
        when matched then update
        set gvb_bezeichnung = r_hwas_geraeteverbund.gvb_bezeichnung,
            gvb_san = r_hwas_geraeteverbund.gvb_san,
            updated = r_hwas_geraeteverbund.updated,
            updated_by = r_hwas_geraeteverbund.updated_by,
            gvb_verbundtyp = r_hwas_geraeteverbund.gvb_verbundtyp,
            typ_uid = r_hwas_geraeteverbund.typ_uid
        when not matched then
        insert (
            gvb_bezeichnung,
            gvb_san,
            inserted,
            inserted_by,
            gvb_verbundtyp,
            typ_uid )
        values
            ( r_hwas_geraeteverbund.gvb_bezeichnung,
              r_hwas_geraeteverbund.gvb_san,
              r_hwas_geraeteverbund.inserted,
              r_hwas_geraeteverbund.inserted_by,
              r_hwas_geraeteverbund.gvb_verbundtyp,
              r_hwas_geraeteverbund.typ_uid );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_geraeteverbund);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_geraeteverbund in hwas_geraeteverbund%rowtype,
        piv_art                 in varchar2
    ) is
        r_hwas_geraeteverbund hwas_geraeteverbund%rowtype;        

-- fuer exceptions        
        v_routine_name        logs.routine_name%type;
        c_message             clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_geraeteverbund := pir_hwas_geraeteverbund;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_geraeteverbund.inserted,
                    r_hwas_geraeteverbund.inserted_by
                from
                    hwas_geraeteverbund
                where
                    gvb_uid = pir_hwas_geraeteverbund.gvb_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_geraeteverbund.updated := sysdate;
                r_hwas_geraeteverbund.updated_by := pck_env.fv_user;
                update hwas_geraeteverbund
                set
                    row = r_hwas_geraeteverbund
                where
                    gvb_uid = pir_hwas_geraeteverbund.gvb_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_geraeteverbund);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_gvb_uid in hwas_geraeteverbund.gvb_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_gvb_uid: ' || to_char(pin_gvb_uid);
        delete from hwas_geraeteverbund
        where
            gvb_uid = pin_gvb_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_geraeteverbund! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_geraeteverbund! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_geraeteverbund_dml;
/

