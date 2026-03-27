-- liquibase formatted sql
-- changeset AM_MAIN:1774600105962 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_elem_geraet_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_elem_geraet_dml.sql:null:d978a4a6f0a44ebeb7426462eea2af9d5a15c4aa:create

create or replace package body am_main.pck_hwas_elem_geraet_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_elem_geraet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'elg_uid = '
                        || to_char(pir_row.elg_uid)
                        || cv_sep
                        || ', mdl_uid = '
                        || to_char(pir_row.mdl_uid)
                        || cv_sep
                        || ', elg_geraetename = '
                        || pir_row.elg_geraetename
                        || cv_sep
                        || ', elg_herstell_inbetrnhm_jahr = '
                        || to_char(pir_row.elg_herstell_inbetrnhm_jahr)
                        || cv_sep
                        || ', rm_uid = '
                        || to_char(pir_row.rm_uid)
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
                        || ', elg_link_fremdsystem = '
                        || pir_row.elg_link_fremdsystem
                        || cv_sep
                        || ', elg_zielsystem = '
                        || pir_row.elg_zielsystem
                        || cv_sep
                        || ', geb_uid = '
                        || to_char(pir_row.geb_uid)
                        || cv_sep
                        || ', hst_uid = '
                        || to_char(pir_row.hst_uid)
                        || cv_sep
                        || ', elg_data_custodian = '
                        || pir_row.elg_data_custodian
                        || cv_sep
                        || ', quellsystem_id = '
                        || to_char(pir_row.quellsystem_id)
                        || cv_sep
                        || ', elg_quellsystem = '
                        || pir_row.elg_quellsystem
                        || cv_sep
                        || ', gvb_uid = '
                        || to_char(pir_row.gvb_uid)
                        || cv_sep
                        || ', fkl_uid = '
                        || to_char(pir_row.fkl_uid)
                        || cv_sep
                        || ', elg_anschaffung_dat = '
                        || to_char(pir_row.elg_anschaffung_dat)
                        || cv_sep
                        || ', elg_inventur_dat = '
                        || to_char(pir_row.elg_inventur_dat)
                        || cv_sep
                        || ', elg_kommentar = '
                        || to_char(pir_row.elg_kommentar)
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
            v_retval := '<table><tr><th>HWAS_ELEM_GERAET</th><th>Column</th></tr>'
                        || '<tr><td>elg_uid</td><td>'
                        || to_char(pir_row.elg_uid)
                        || '</td></tr>'
                        || '<tr><td>mdl_uid</td><td>'
                        || to_char(pir_row.mdl_uid)
                        || '</td></tr>'
                        || '<tr><td>elg_geraetename</td><td>'
                        || pir_row.elg_geraetename
                        || '</td></tr>'
                        || '<tr><td>elg_herstell_inbetrnhm_jahr</td><td>'
                        || to_char(pir_row.elg_herstell_inbetrnhm_jahr)
                        || '</td></tr>'
                        || '<tr><td>rm_uid</td><td>'
                        || to_char(pir_row.rm_uid)
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
                        || '<tr><td>elg_link_fremdsystem</td><td>'
                        || pir_row.elg_link_fremdsystem
                        || '</td></tr>'
                        || '<tr><td>elg_zielsystem</td><td>'
                        || pir_row.elg_zielsystem
                        || '</td></tr>'
                        || '<tr><td>geb_uid</td><td>'
                        || to_char(pir_row.geb_uid)
                        || '</td></tr>'
                        || '<tr><td>hst_uid</td><td>'
                        || to_char(pir_row.hst_uid)
                        || '</td></tr>'
                        || '<tr><td>elg_data_custodian</td><td>'
                        || pir_row.elg_data_custodian
                        || '</td></tr>'
                        || '<tr><td>quellsystem_id</td><td>'
                        || to_char(pir_row.quellsystem_id)
                        || '</td></tr>'
                        || '<tr><td>elg_quellsystem</td><td>'
                        || pir_row.elg_quellsystem
                        || '</td></tr>'
                        || '<tr><td>gvb_uid</td><td>'
                        || to_char(pir_row.gvb_uid)
                        || '</td></tr>'
                        || '<tr><td>fkl_uid</td><td>'
                        || to_char(pir_row.fkl_uid)
                        || '</td></tr>'
                        || '<tr><td>elg_anschaffung_dat</td><td>'
                        || to_char(pir_row.elg_anschaffung_dat)
                        || '</td></tr>'
                        || '<tr><td>elg_inventur_dat</td><td>'
                        || to_char(pir_row.elg_inventur_dat)
                        || '</td></tr>'
                        || '<tr><td>elg_kommentar</td><td>'
                        || to_char(pir_row.elg_kommentar)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_elem_geraet in out hwas_elem_geraet%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_elem_geraet.inserted := sysdate;
        pior_hwas_elem_geraet.inserted_by := pck_env.fv_user;
        insert into hwas_elem_geraet values pior_hwas_elem_geraet returning elg_uid into pior_hwas_elem_geraet.elg_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_elem_geraet! Parameter: ' || fv_print(pir_row => pior_hwas_elem_geraet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_elem_geraet in hwas_elem_geraet%rowtype
    ) is
        r_hwas_elem_geraet hwas_elem_geraet%rowtype;

  -- fuer exceptions
        v_routine_name     logs.routine_name%type;
        c_message          clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_elem_geraet := pir_hwas_elem_geraet;
        r_hwas_elem_geraet.inserted := sysdate;
        r_hwas_elem_geraet.updated := sysdate;
        r_hwas_elem_geraet.inserted_by := pck_env.fv_user;
        r_hwas_elem_geraet.updated_by := pck_env.fv_user;
        merge into hwas_elem_geraet
        using dual on ( elg_uid = r_hwas_elem_geraet.elg_uid )
        when matched then update
        set mdl_uid = r_hwas_elem_geraet.mdl_uid,
            elg_geraetename = r_hwas_elem_geraet.elg_geraetename,
            elg_herstell_inbetrnhm_jahr = r_hwas_elem_geraet.elg_herstell_inbetrnhm_jahr,
            rm_uid = r_hwas_elem_geraet.rm_uid,
            updated = r_hwas_elem_geraet.updated,
            updated_by = r_hwas_elem_geraet.updated_by,
            elg_link_fremdsystem = r_hwas_elem_geraet.elg_link_fremdsystem,
            elg_zielsystem = r_hwas_elem_geraet.elg_zielsystem,
            geb_uid = r_hwas_elem_geraet.geb_uid,
            hst_uid = r_hwas_elem_geraet.hst_uid,
            elg_data_custodian = r_hwas_elem_geraet.elg_data_custodian,
            quellsystem_id = r_hwas_elem_geraet.quellsystem_id,
            elg_quellsystem = r_hwas_elem_geraet.elg_quellsystem,
            gvb_uid = r_hwas_elem_geraet.gvb_uid,
            fkl_uid = r_hwas_elem_geraet.fkl_uid,
            elg_anschaffung_dat = r_hwas_elem_geraet.elg_anschaffung_dat,
            elg_inventur_dat = r_hwas_elem_geraet.elg_inventur_dat,
            elg_kommentar = r_hwas_elem_geraet.elg_kommentar,
            status = r_hwas_elem_geraet.status
        when not matched then
        insert (
            mdl_uid,
            elg_geraetename,
            elg_herstell_inbetrnhm_jahr,
            rm_uid,
            inserted,
            inserted_by,
            elg_link_fremdsystem,
            elg_zielsystem,
            geb_uid,
            hst_uid,
            elg_data_custodian,
            quellsystem_id,
            elg_quellsystem,
            gvb_uid,
            fkl_uid,
            elg_anschaffung_dat,
            elg_inventur_dat,
            elg_kommentar,
            status )
        values
            ( r_hwas_elem_geraet.mdl_uid,
              r_hwas_elem_geraet.elg_geraetename,
              r_hwas_elem_geraet.elg_herstell_inbetrnhm_jahr,
              r_hwas_elem_geraet.rm_uid,
              r_hwas_elem_geraet.inserted,
              r_hwas_elem_geraet.inserted_by,
              r_hwas_elem_geraet.elg_link_fremdsystem,
              r_hwas_elem_geraet.elg_zielsystem,
              r_hwas_elem_geraet.geb_uid,
              r_hwas_elem_geraet.hst_uid,
              r_hwas_elem_geraet.elg_data_custodian,
              r_hwas_elem_geraet.quellsystem_id,
              r_hwas_elem_geraet.elg_quellsystem,
              r_hwas_elem_geraet.gvb_uid,
              r_hwas_elem_geraet.fkl_uid,
              r_hwas_elem_geraet.elg_anschaffung_dat,
              r_hwas_elem_geraet.elg_inventur_dat,
              r_hwas_elem_geraet.elg_kommentar,
              r_hwas_elem_geraet.status );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_elem_geraet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------
/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_elem_geraet in hwas_elem_geraet%rowtype,
        piv_art              in varchar2
    ) is
        r_hwas_elem_geraet hwas_elem_geraet%rowtype;        

-- fuer exceptions        
        v_routine_name     logs.routine_name%type;
        c_message          clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_elem_geraet := pir_hwas_elem_geraet;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_elem_geraet.inserted,
                    r_hwas_elem_geraet.inserted_by
                from
                    hwas_elem_geraet
                where
                    elg_uid = pir_hwas_elem_geraet.elg_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_elem_geraet.updated := sysdate;
                r_hwas_elem_geraet.updated_by := pck_env.fv_user;
                update hwas_elem_geraet
                set
                    row = r_hwas_elem_geraet
                where
                    elg_uid = pir_hwas_elem_geraet.elg_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_elem_geraet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_elg_uid in hwas_elem_geraet.elg_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_elg_uid: ' || to_char(pin_elg_uid);
        delete from hwas_elem_geraet
        where
            elg_uid = pin_elg_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_elem_geraet! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_elem_geraet! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_elem_geraet_dml;
/

