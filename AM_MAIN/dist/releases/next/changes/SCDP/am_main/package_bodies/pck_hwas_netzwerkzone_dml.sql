-- liquibase formatted sql
-- changeset AM_MAIN:1774556570649 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_netzwerkzone_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_netzwerkzone_dml.sql:null:ff7b8aed3dc59db44a60e68b79b7210747690e66:create

create or replace package body am_main.pck_hwas_netzwerkzone_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_netzwerkzone%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'NZONE_UID = '
                        || to_char(pir_row.nzone_uid)
                        || cv_sep
                        || ', NZONE_BEZEICHNUNG = '
                        || pir_row.nzone_bezeichnung
                        || cv_sep
                        || ', NZONE_BESCHREIBUNG = '
                        || pir_row.nzone_beschreibung
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
            v_retval := '<table><tr><th>HWAS_NETZWERKZONE</th><th>Column</th></tr>'
                        || '<tr><td>NZONE_UID</td><td>'
                        || to_char(pir_row.nzone_uid)
                        || '</td></tr>'
                        || '<tr><td>NZONE_BEZEICHNUNG</td><td>'
                        || pir_row.nzone_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>NZONE_BESCHREIBUNG</td><td>'
                        || pir_row.nzone_beschreibung
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
        pior_hwas_netzwerkzone in out hwas_netzwerkzone%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_netzwerkzone.inserted := sysdate;
        pior_hwas_netzwerkzone.inserted_by := pck_env.fv_user;
        insert into hwas_netzwerkzone values pior_hwas_netzwerkzone returning nzone_uid into pior_hwas_netzwerkzone.nzone_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle HWAS_NETZWERKZONE! Parameter: ' || fv_print(pir_row => pior_hwas_netzwerkzone)
            ;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_netzwerkzone in hwas_netzwerkzone%rowtype
    ) is
        r_hwas_netzwerkzone hwas_netzwerkzone%rowtype;

  -- fuer exceptions
        v_routine_name      logs.routine_name%type;
        c_message           clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_netzwerkzone := pir_hwas_netzwerkzone;
        r_hwas_netzwerkzone.inserted := sysdate;
        r_hwas_netzwerkzone.updated := sysdate;
        r_hwas_netzwerkzone.inserted_by := pck_env.fv_user;
        r_hwas_netzwerkzone.updated_by := pck_env.fv_user;
        merge into hwas_netzwerkzone
        using dual on ( nzone_uid = r_hwas_netzwerkzone.nzone_uid )
        when matched then update
        set nzone_bezeichnung = r_hwas_netzwerkzone.nzone_bezeichnung,
            nzone_beschreibung = r_hwas_netzwerkzone.nzone_beschreibung,
            updated = r_hwas_netzwerkzone.updated,
            updated_by = r_hwas_netzwerkzone.updated_by
        when not matched then
        insert (
            nzone_bezeichnung,
            nzone_beschreibung,
            inserted,
            inserted_by )
        values
            ( r_hwas_netzwerkzone.nzone_bezeichnung,
              r_hwas_netzwerkzone.nzone_beschreibung,
              r_hwas_netzwerkzone.inserted,
              r_hwas_netzwerkzone.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_netzwerkzone);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_netzwerkzone in hwas_netzwerkzone%rowtype,
        piv_art               in varchar2
    ) is
        r_hwas_netzwerkzone hwas_netzwerkzone%rowtype;

  -- fuer exceptions
        v_routine_name      logs.routine_name%type;
        c_message           clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_netzwerkzone.nzone_bezeichnung := pir_hwas_netzwerkzone.nzone_bezeichnung;
        r_hwas_netzwerkzone.nzone_beschreibung := pir_hwas_netzwerkzone.nzone_beschreibung;
        r_hwas_netzwerkzone.updated := sysdate;
        r_hwas_netzwerkzone.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update hwas_netzwerkzone
                set
                    nzone_uid = pir_hwas_netzwerkzone.nzone_uid
                where
                    nzone_uid = pir_hwas_netzwerkzone.nzone_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_netzwerkzone := pir_hwas_netzwerkzone;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_netzwerkzone.inserted,
                    r_hwas_netzwerkzone.inserted_by
                from
                    hwas_netzwerkzone
                where
                    nzone_uid = pir_hwas_netzwerkzone.nzone_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_netzwerkzone.updated := sysdate;
                r_hwas_netzwerkzone.updated_by := pck_env.fv_user;
                update hwas_netzwerkzone
                set
                    row = r_hwas_netzwerkzone
                where
                    nzone_uid = pir_hwas_netzwerkzone.nzone_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_netzwerkzone);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_nzone_uid in hwas_netzwerkzone.nzone_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_NZONE_UID: ' || to_char(pin_nzone_uid);
        delete from hwas_netzwerkzone
        where
            nzone_uid = pin_nzone_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle HWAS_NETZWERKZONE! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle HWAS_NETZWERKZONE! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_netzwerkzone_dml;
/

