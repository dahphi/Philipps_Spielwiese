-- liquibase formatted sql
-- changeset RK_MAIN:1774561690968 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_asm_am_asset_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_asm_am_asset_dml.sql:null:a2a318080c366526c03eed93f38489e1521de91b:create

create or replace package body rk_main.pck_asm_am_asset_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in asm_am_asset%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ass_uid = '
                        || to_char(pir_row.ass_uid)
                        || cv_sep
                        || ', ass_id = '
                        || pir_row.ass_id
                        || cv_sep
                        || ', ass_beschreibung = '
                        || pir_row.ass_beschreibung
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
                        || ', ass_spot_referenz = '
                        || pir_row.ass_spot_referenz
                        || cv_sep
                        || ', gek_lfd_nr = '
                        || to_char(pir_row.gek_lfd_nr)
                        || cv_sep
                        || ', ass_kritis_relevant = '
                        || to_char(pir_row.ass_kritis_relevant)
                        || cv_sep
                        || ', aut_lfd_nr = '
                        || to_char(pir_row.aut_lfd_nr)
                        || cv_sep
                        || ', int_lfd_nr = '
                        || to_char(pir_row.int_lfd_nr)
                        || cv_sep
                        || ', vef_lfd_nr = '
                        || to_char(pir_row.vef_lfd_nr)
                        || cv_sep
                        || ', vet_lfd_nr = '
                        || to_char(pir_row.vet_lfd_nr)
                        || cv_sep
                        || ', ass_dataowner_san = '
                        || pir_row.ass_dataowner_san
                        || cv_sep
                        || ', ass_custodian_san = '
                        || pir_row.ass_custodian_san
                        || cv_sep
                        || ', fkl_uid = '
                        || pir_row.fkl_uid
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
            v_retval := '<table><tr><th>ASM_AM_ASSET</th><th>Column</th></tr>'
                        || '<tr><td>ass_uid</td><td>'
                        || to_char(pir_row.ass_uid)
                        || '</td></tr>'
                        || '<tr><td>ass_id</td><td>'
                        || pir_row.ass_id
                        || '</td></tr>'
                        || '<tr><td>ass_beschreibung</td><td>'
                        || pir_row.ass_beschreibung
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
                        || '<tr><td>ass_spot_referenz</td><td>'
                        || pir_row.ass_spot_referenz
                        || '</td></tr>'
                        || '<tr><td>gek_lfd_nr</td><td>'
                        || to_char(pir_row.gek_lfd_nr)
                        || '</td></tr>'
                        || '<tr><td>ass_kritis_relevant</td><td>'
                        || to_char(pir_row.ass_kritis_relevant)
                        || '</td></tr>'
                        || '<tr><td>aut_lfd_nr</td><td>'
                        || to_char(pir_row.aut_lfd_nr)
                        || '</td></tr>'
                        || '<tr><td>int_lfd_nr</td><td>'
                        || to_char(pir_row.int_lfd_nr)
                        || '</td></tr>'
                        || '<tr><td>vef_lfd_nr</td><td>'
                        || to_char(pir_row.vef_lfd_nr)
                        || '</td></tr>'
                        || '<tr><td>vet_lfd_nr</td><td>'
                        || to_char(pir_row.vet_lfd_nr)
                        || '</td></tr>'
                        || '<tr><td>ass_dataowner_san</td><td>'
                        || pir_row.ass_dataowner_san
                        || '</td></tr>'
                        || '<tr><td>ass_custodian_san</td><td>'
                        || pir_row.ass_custodian_san
                        || '</td></tr>'
                        || '<tr><td>fkl_uid</td><td>'
                        || pir_row.fkl_uid
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_asm_am_asset in out asm_am_asset%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_asm_am_asset.inserted := sysdate;
        pior_asm_am_asset.inserted_by := pck_env.fv_user;
        insert into asm_am_asset values pior_asm_am_asset returning ass_uid into pior_asm_am_asset.ass_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle asm_am_asset! Parameter: ' || fv_print(pir_row => pior_asm_am_asset);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_asm_am_asset in asm_am_asset%rowtype
    ) is
        r_asm_am_asset asm_am_asset%rowtype;

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_asm_am_asset := pir_asm_am_asset;
        r_asm_am_asset.inserted := sysdate;
        r_asm_am_asset.updated := sysdate;
        r_asm_am_asset.inserted_by := pck_env.fv_user;
        r_asm_am_asset.updated_by := pck_env.fv_user;
        merge into asm_am_asset
        using dual on ( ass_uid = r_asm_am_asset.ass_uid )
        when matched then update
        set ass_id = r_asm_am_asset.ass_id,
            ass_beschreibung = r_asm_am_asset.ass_beschreibung,
            updated = r_asm_am_asset.updated,
            updated_by = r_asm_am_asset.updated_by,
            ass_spot_referenz = r_asm_am_asset.ass_spot_referenz,
            gek_lfd_nr = r_asm_am_asset.gek_lfd_nr,
            ass_kritis_relevant = r_asm_am_asset.ass_kritis_relevant,
            aut_lfd_nr = r_asm_am_asset.aut_lfd_nr,
            int_lfd_nr = r_asm_am_asset.int_lfd_nr,
            vef_lfd_nr = r_asm_am_asset.vef_lfd_nr,
            vet_lfd_nr = r_asm_am_asset.vet_lfd_nr,
            ass_dataowner_san = r_asm_am_asset.ass_dataowner_san,
            ass_custodian_san = r_asm_am_asset.ass_custodian_san,
            fkl_uid = r_asm_am_asset.fkl_uid
        when not matched then
        insert (
            ass_id,
            ass_beschreibung,
            inserted,
            inserted_by,
            ass_spot_referenz,
            gek_lfd_nr,
            ass_kritis_relevant,
            aut_lfd_nr,
            int_lfd_nr,
            vef_lfd_nr,
            vet_lfd_nr,
            ass_dataowner_san,
            ass_custodian_san,
            fkl_uid )
        values
            ( r_asm_am_asset.ass_id,
              r_asm_am_asset.ass_beschreibung,
              r_asm_am_asset.inserted,
              r_asm_am_asset.inserted_by,
              r_asm_am_asset.ass_spot_referenz,
              r_asm_am_asset.gek_lfd_nr,
              r_asm_am_asset.ass_kritis_relevant,
              r_asm_am_asset.aut_lfd_nr,
              r_asm_am_asset.int_lfd_nr,
              r_asm_am_asset.vef_lfd_nr,
              r_asm_am_asset.vet_lfd_nr,
              r_asm_am_asset.ass_dataowner_san,
              r_asm_am_asset.ass_custodian_san,
              r_asm_am_asset.fkl_uid );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_asm_am_asset);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_asm_am_asset in asm_am_asset%rowtype,
        piv_art          in varchar2
    ) is
        r_asm_am_asset asm_am_asset%rowtype;        

-- fuer exceptions        
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_asm_am_asset := pir_asm_am_asset;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_asm_am_asset.inserted,
                    r_asm_am_asset.inserted_by
                from
                    asm_am_asset
                where
                    ass_uid = pir_asm_am_asset.ass_uid;  
      -- Ergänzen der Update-Daten  
                r_asm_am_asset.updated := sysdate;
                r_asm_am_asset.updated_by := pck_env.fv_user;
                update asm_am_asset
                set
                    row = r_asm_am_asset
                where
                    ass_uid = pir_asm_am_asset.ass_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_asm_am_asset);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ass_uid in asm_am_asset.ass_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ass_uid: ' || to_char(pin_ass_uid);
        delete from asm_am_asset
        where
            ass_uid = pin_ass_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle asm_am_asset! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle asm_am_asset! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_asm_am_asset_dml;
/

