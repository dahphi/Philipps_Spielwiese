-- liquibase formatted sql
-- changeset AM_MAIN:1774557119430 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_virtuelle_maschinen_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_virtuelle_maschinen_dml.sql:null:b841f28d02a701bf5da371ca63895c6c46e80f12:create

create or replace package body am_main.pck_hwas_virtuelle_maschinen_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_virtuelle_maschinen%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'vm_uid = '
                        || to_char(pir_row.vm_uid)
                        || cv_sep
                        || ', vm_bezeichnung = '
                        || pir_row.vm_bezeichnung
                        || cv_sep
                        || ', vm_host = '
                        || to_char(pir_row.vm_host)
                        || cv_sep
                --|| ', vm_unit = '          || pir_row.vm_unit            || cv_sep
                --|| ', vm_dptgrp = '        || pir_row.vm_dptgrp          || cv_sep
                        || ', vm_san = '
                        || pir_row.vm_san
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
                        || ', vm_link_wiki = '
                        || pir_row.vm_link_wiki
                        || cv_sep
                        || ', vm_beschreibung = '
                        || pir_row.vm_beschreibung
                        || cv_sep
                        || ', LZ_ID_FK = '
                        || pir_row.lz_id_fk
                        || cv_sep
                        || ', Umgebung = '
                        || pir_row.umgebung
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
            v_retval := '<table><tr><th>HWAS_VIRTUELLE_MASCHINEN</th><th>Column</th></tr>'
                        || '<tr><td>vm_uid</td><td>'
                        || to_char(pir_row.vm_uid)
                        || '</td></tr>'
                        || '<tr><td>vm_bezeichnung</td><td>'
                        || pir_row.vm_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>vm_host</td><td>'
                        || to_char(pir_row.vm_host)
                        || '</td></tr>'
                --|| '<tr><td>vm_unit</td><td>'          || pir_row.vm_unit                || '</td></tr>'
                --|| '<tr><td>vm_dptgrp</td><td>'        || pir_row.vm_dptgrp              || '</td></tr>'
                        || '<tr><td>vm_san</td><td>'
                        || pir_row.vm_san
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
                        || '<tr><td>vm_link_wiki</td><td>'
                        || pir_row.vm_link_wiki
                        || '</td></tr>'
                        || '<tr><td>vm_beschreibung</td><td>'
                        || pir_row.vm_beschreibung
                        || '</td></tr>'
                        || '<tr><td>LZ_ID_FK</td><td>'
                        || pir_row.lz_id_fk
                        || '</td></tr>'
                        || '<tr><td>IP_ADRESSE</td><td>'
                        || pir_row.ip_adresse
                        || '</td></tr>'
                        || '<tr><td>Umgebung</td><td>'
                        || pir_row.umgebung
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_virtuelle_maschinen in out hwas_virtuelle_maschinen%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_virtuelle_maschinen.inserted := sysdate;
        pior_hwas_virtuelle_maschinen.inserted_by := pck_env.fv_user;
        insert into hwas_virtuelle_maschinen values pior_hwas_virtuelle_maschinen returning vm_uid into pior_hwas_virtuelle_maschinen.vm_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_virtuelle_maschinen! Parameter: ' || fv_print(pir_row => pior_hwas_virtuelle_maschinen
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_virtuelle_maschinen in hwas_virtuelle_maschinen%rowtype
    ) is
        r_hwas_virtuelle_maschinen hwas_virtuelle_maschinen%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_virtuelle_maschinen := pir_hwas_virtuelle_maschinen;
        r_hwas_virtuelle_maschinen.inserted := sysdate;
        r_hwas_virtuelle_maschinen.updated := sysdate;
        r_hwas_virtuelle_maschinen.inserted_by := pck_env.fv_user;
        r_hwas_virtuelle_maschinen.updated_by := pck_env.fv_user;
        merge into hwas_virtuelle_maschinen
        using dual on ( vm_uid = r_hwas_virtuelle_maschinen.vm_uid )
        when matched then update
        set vm_bezeichnung = r_hwas_virtuelle_maschinen.vm_bezeichnung,
            vm_host = r_hwas_virtuelle_maschinen.vm_host
      --, vm_unit           = r_hwas_virtuelle_maschinen.vm_unit
      --, vm_dptgrp         = r_hwas_virtuelle_maschinen.vm_dptgrp
            ,
            vm_san = r_hwas_virtuelle_maschinen.vm_san,
            updated = r_hwas_virtuelle_maschinen.updated,
            updated_by = r_hwas_virtuelle_maschinen.updated_by,
            vm_link_wiki = r_hwas_virtuelle_maschinen.vm_link_wiki,
            vm_beschreibung = r_hwas_virtuelle_maschinen.vm_beschreibung,
            nzone_uid = r_hwas_virtuelle_maschinen.nzone_uid,
            lz_id_fk = r_hwas_virtuelle_maschinen.lz_id_fk,
            ip_adresse = r_hwas_virtuelle_maschinen.ip_adresse,
            umgebung = r_hwas_virtuelle_maschinen.umgebung,
            sza_ueberwachung = r_hwas_virtuelle_maschinen.sza_ueberwachung,
            ruf_uid_fk = r_hwas_virtuelle_maschinen.ruf_uid_fk
        when not matched then
        insert (
            vm_bezeichnung,
            vm_host
      --, vm_unit
      --, vm_dptgrp
            ,
            vm_san,
            inserted,
            inserted_by,
            vm_link_wiki,
            vm_beschreibung,
            nzone_uid,
            lz_id_fk,
            ip_adresse,
            umgebung,
            sza_ueberwachung,
            ruf_uid_fk )
        values
            ( r_hwas_virtuelle_maschinen.vm_bezeichnung,
              r_hwas_virtuelle_maschinen.vm_host
      --, r_hwas_virtuelle_maschinen.vm_unit
     -- , r_hwas_virtuelle_maschinen.vm_dptgrp
              ,
              r_hwas_virtuelle_maschinen.vm_san,
              r_hwas_virtuelle_maschinen.inserted,
              r_hwas_virtuelle_maschinen.inserted_by,
              r_hwas_virtuelle_maschinen.vm_link_wiki,
              r_hwas_virtuelle_maschinen.vm_beschreibung,
              r_hwas_virtuelle_maschinen.nzone_uid,
              r_hwas_virtuelle_maschinen.lz_id_fk,
              r_hwas_virtuelle_maschinen.ip_adresse,
              r_hwas_virtuelle_maschinen.umgebung,
              r_hwas_virtuelle_maschinen.sza_ueberwachung,
              r_hwas_virtuelle_maschinen.ruf_uid_fk );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_virtuelle_maschinen);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------
/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_virtuelle_maschinen in hwas_virtuelle_maschinen%rowtype,
        piv_art                      in varchar2
    ) is
        r_hwas_virtuelle_maschinen hwas_virtuelle_maschinen%rowtype;        

-- fuer exceptions        
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_virtuelle_maschinen := pir_hwas_virtuelle_maschinen;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_virtuelle_maschinen.inserted,
                    r_hwas_virtuelle_maschinen.inserted_by
                from
                    hwas_virtuelle_maschinen
                where
                    vm_uid = pir_hwas_virtuelle_maschinen.vm_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_virtuelle_maschinen.updated := sysdate;
                r_hwas_virtuelle_maschinen.updated_by := pck_env.fv_user;
                update hwas_virtuelle_maschinen
                set
                    row = r_hwas_virtuelle_maschinen
                where
                    vm_uid = pir_hwas_virtuelle_maschinen.vm_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_virtuelle_maschinen);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        
---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_vm_uid in hwas_virtuelle_maschinen.vm_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_vm_uid: ' || to_char(pin_vm_uid);
        delete from hwas_virtuelle_maschinen
        where
            vm_uid = pin_vm_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_virtuelle_maschinen! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_virtuelle_maschinen! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_virtuelle_maschinen_dml;
/

