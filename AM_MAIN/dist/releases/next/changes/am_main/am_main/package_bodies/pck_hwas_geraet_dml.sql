-- liquibase formatted sql
-- changeset AM_MAIN:1774600109050 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_geraet_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_geraet_dml.sql:null:f6bbe3a500482bba618d491667335c9533caf39a:create

create or replace package body am_main.pck_hwas_geraet_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_geraet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'grt_uid = '
                        || to_char(pir_row.grt_uid)
                        || cv_sep
                        || ', grt_inventartnr = '
                        || pir_row.grt_inventartnr
                        || cv_sep
                        || ', mdl_uid = '
                        || to_char(pir_row.mdl_uid)
                        || cv_sep
                        || ', grt_assetname = '
                        || pir_row.grt_assetname
                        || cv_sep
                        || ', grt_herstell_inbetrnhm_jahr = '
                        || to_char(pir_row.grt_herstell_inbetrnhm_jahr)
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
                        || ', grt_link_fremdsystem = '
                        || pir_row.grt_link_fremdsystem
                        || cv_sep
                        || ', grt_zielsystem = '
                        || pir_row.grt_zielsystem
                        || cv_sep
               -- || ', geb_uid = '                      || TO_CHAR( pir_row.geb_uid ) || cv_sep
                        || ', hst_uid = '
                        || to_char(pir_row.hst_uid)
                        || cv_sep
                        || ', grt_data_custodian = '
                        || pir_row.grt_data_custodian
                        || cv_sep
                        || ', quellsystem_id = '
                        || to_char(pir_row.quellsystem_id)
                        || cv_sep
                        || ', grt_quellsystem = '
                        || pir_row.grt_quellsystem
                        || cv_sep
                        || ', gvb_uid = '
                        || to_char(pir_row.gvb_uid)
                        || cv_sep
                        || ', fkl_uid = '
                        || to_char(pir_row.fkl_uid)
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
            v_retval := '<table><tr><th>HWAS_GERAET</th><th>Column</th></tr>'
                        || '<tr><td>grt_uid</td><td>'
                        || to_char(pir_row.grt_uid)
                        || '</td></tr>'
                        || '<tr><td>grt_inventartnr</td><td>'
                        || pir_row.grt_inventartnr
                        || '</td></tr>'
                        || '<tr><td>mdl_uid</td><td>'
                        || to_char(pir_row.mdl_uid)
                        || '</td></tr>'
                        || '<tr><td>grt_assetname</td><td>'
                        || pir_row.grt_assetname
                        || '</td></tr>'
                        || '<tr><td>grt_herstell_inbetrnhm_jahr</td><td>'
                        || to_char(pir_row.grt_herstell_inbetrnhm_jahr)
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
                        || '<tr><td>grt_link_fremdsystem</td><td>'
                        || pir_row.grt_link_fremdsystem
                        || '</td></tr>'
                        || '<tr><td>grt_zielsystem</td><td>'
                        || pir_row.grt_zielsystem
                        || '</td></tr>'
                --|| '<tr><td>geb_uid</td><td>'                      || TO_CHAR( pir_row.geb_uid )     || '</td></tr>'
                        || '<tr><td>hst_uid</td><td>'
                        || to_char(pir_row.hst_uid)
                        || '</td></tr>'
                        || '<tr><td>grt_data_custodian</td><td>'
                        || pir_row.grt_data_custodian
                        || '</td></tr>'
                        || '<tr><td>quellsystem_id</td><td>'
                        || to_char(pir_row.quellsystem_id)
                        || '</td></tr>'
                        || '<tr><td>grt_quellsystem</td><td>'
                        || pir_row.grt_quellsystem
                        || '</td></tr>'
                        || '<tr><td>gvb_uid</td><td>'
                        || to_char(pir_row.gvb_uid)
                        || '</td></tr>'
                        || '<tr><td>fkl_uid</td><td>'
                        || to_char(pir_row.fkl_uid)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_geraet in out hwas_geraet%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_geraet.inserted := sysdate;
        pior_hwas_geraet.inserted_by := pck_env.fv_user;
        insert into hwas_geraet values pior_hwas_geraet returning grt_uid into pior_hwas_geraet.grt_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_geraet! Parameter: ' || fv_print(pir_row => pior_hwas_geraet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_geraet in hwas_geraet%rowtype
    ) is
        r_hwas_geraet  hwas_geraet%rowtype;

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_geraet := pir_hwas_geraet;
        r_hwas_geraet.inserted := sysdate;
        r_hwas_geraet.updated := sysdate;
        r_hwas_geraet.inserted_by := pck_env.fv_user;
        r_hwas_geraet.updated_by := pck_env.fv_user;
        merge into hwas_geraet
        using dual on ( grt_uid = r_hwas_geraet.grt_uid )
        when matched then update
        set grt_inventartnr = r_hwas_geraet.grt_inventartnr,
            mdl_uid = r_hwas_geraet.mdl_uid,
            grt_assetname = r_hwas_geraet.grt_assetname,
            grt_herstell_inbetrnhm_jahr = r_hwas_geraet.grt_herstell_inbetrnhm_jahr,
            rm_uid = r_hwas_geraet.rm_uid,
            updated = r_hwas_geraet.updated,
            updated_by = r_hwas_geraet.updated_by,
            grt_link_fremdsystem = r_hwas_geraet.grt_link_fremdsystem,
            grt_zielsystem = r_hwas_geraet.grt_zielsystem,
            geb_uid = r_hwas_geraet.geb_uid,
            hst_uid = r_hwas_geraet.hst_uid,
            grt_data_custodian = r_hwas_geraet.grt_data_custodian,
            quellsystem_id = r_hwas_geraet.quellsystem_id,
            grt_quellsystem = r_hwas_geraet.grt_quellsystem,
            gvb_uid = r_hwas_geraet.gvb_uid,
            fkl_uid = r_hwas_geraet.fkl_uid,
            status = r_hwas_geraet.status
        when not matched then
        insert (
            grt_inventartnr,
            mdl_uid,
            grt_assetname,
            grt_herstell_inbetrnhm_jahr,
            rm_uid,
            inserted,
            inserted_by,
            grt_link_fremdsystem,
            grt_zielsystem,
            geb_uid,
            hst_uid,
            grt_data_custodian,
            quellsystem_id,
            grt_quellsystem,
            gvb_uid,
            fkl_uid,
            status )
        values
            ( r_hwas_geraet.grt_inventartnr,
              r_hwas_geraet.mdl_uid,
              r_hwas_geraet.grt_assetname,
              r_hwas_geraet.grt_herstell_inbetrnhm_jahr,
              r_hwas_geraet.rm_uid,
              r_hwas_geraet.inserted,
              r_hwas_geraet.inserted_by,
              r_hwas_geraet.grt_link_fremdsystem,
              r_hwas_geraet.grt_zielsystem,
              r_hwas_geraet.geb_uid,
              r_hwas_geraet.hst_uid,
              r_hwas_geraet.grt_data_custodian,
              r_hwas_geraet.quellsystem_id,
              r_hwas_geraet.grt_quellsystem,
              r_hwas_geraet.gvb_uid,
              r_hwas_geraet.fkl_uid,
              r_hwas_geraet.status );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_geraet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_geraet in hwas_geraet%rowtype,
        piv_art         in varchar2
    ) is
        r_hwas_geraet  hwas_geraet%rowtype;        

-- fuer exceptions        
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_geraet := pir_hwas_geraet;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_geraet.inserted,
                    r_hwas_geraet.inserted_by
                from
                    hwas_geraet
                where
                    grt_uid = pir_hwas_geraet.grt_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_geraet.updated := sysdate;
                r_hwas_geraet.updated_by := pck_env.fv_user;
                update hwas_geraet
                set
                    row = r_hwas_geraet
                where
                    grt_uid = pir_hwas_geraet.grt_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_geraet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_grt_uid in hwas_geraet.grt_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_grt_uid: ' || to_char(pin_grt_uid);
        delete from hwas_geraet
        where
            grt_uid = pin_grt_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_geraet! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_geraet! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_geraet_dml;
/

