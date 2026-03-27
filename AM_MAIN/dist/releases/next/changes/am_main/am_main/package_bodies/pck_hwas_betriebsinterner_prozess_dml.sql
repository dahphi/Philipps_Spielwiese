-- liquibase formatted sql
-- changeset AM_MAIN:1774600104477 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_betriebsinterner_prozess_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_betriebsinterner_prozess_dml.sql:null:c67e2ed75c00cbd14d640fc9e6a9a966fa531728:create

create or replace package body am_main.pck_hwas_betriebsinterner_prozess_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_betriebsinterner_prozess%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'bip_uid = '
                        || to_char(pir_row.bip_uid)
                        || cv_sep
                        || ', bip_bezeichnung = '
                        || pir_row.bip_bezeichnung
                        || cv_sep
                        || ', ak3_uid = '
                        || to_char(pir_row.ak3_uid)
                        || cv_sep
                        || ', bip_zusammenfassung = '
                        || pir_row.bip_zusammenfassung
                        || cv_sep
                        || ', bip_abhaenigkeit_logistik = '
                        || to_char(pir_row.bip_abhaenigkeit_logistik)
                        || cv_sep
                        || ', bip_bescheibung_abh_log = '
                        || pir_row.bip_bescheibung_abh_log
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
            v_retval := '<table><tr><th>HWAS_BETRIEBSINTERNER_PROZESS</th><th>Column</th></tr>'
                        || '<tr><td>bip_uid</td><td>'
                        || to_char(pir_row.bip_uid)
                        || '</td></tr>'
                        || '<tr><td>bip_bezeichnung</td><td>'
                        || pir_row.bip_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>ak3_uid</td><td>'
                        || to_char(pir_row.ak3_uid)
                        || '</td></tr>'
                        || '<tr><td>bip_zusammenfassung</td><td>'
                        || pir_row.bip_zusammenfassung
                        || '</td></tr>'
                        || '<tr><td>bip_abhaenigkeit_logistik</td><td>'
                        || to_char(pir_row.bip_abhaenigkeit_logistik)
                        || '</td></tr>'
                        || '<tr><td>bip_bescheibung_abh_log</td><td>'
                        || pir_row.bip_bescheibung_abh_log
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
        pior_hwas_betriebsinterner_prozess in out hwas_betriebsinterner_prozess%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_betriebsinterner_prozess.inserted := sysdate;
        pior_hwas_betriebsinterner_prozess.inserted_by := pck_env.fv_user;
        insert into hwas_betriebsinterner_prozess values pior_hwas_betriebsinterner_prozess returning bip_uid into pior_hwas_betriebsinterner_prozess.bip_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_betriebsinterner_prozess! Parameter: ' || fv_print(pir_row => pior_hwas_betriebsinterner_prozess
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_betriebsinterner_prozess in hwas_betriebsinterner_prozess%rowtype
    ) is
        r_hwas_betriebsinterner_prozess hwas_betriebsinterner_prozess%rowtype;

  -- fuer exceptions
        v_routine_name                  logs.routine_name%type;
        c_message                       clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_betriebsinterner_prozess := pir_hwas_betriebsinterner_prozess;
        r_hwas_betriebsinterner_prozess.inserted := sysdate;
        r_hwas_betriebsinterner_prozess.updated := sysdate;
        r_hwas_betriebsinterner_prozess.inserted_by := pck_env.fv_user;
        r_hwas_betriebsinterner_prozess.updated_by := pck_env.fv_user;
        merge into hwas_betriebsinterner_prozess
        using dual on ( bip_uid = r_hwas_betriebsinterner_prozess.bip_uid )
        when matched then update
        set bip_bezeichnung = r_hwas_betriebsinterner_prozess.bip_bezeichnung,
            ak3_uid = r_hwas_betriebsinterner_prozess.ak3_uid,
            bip_zusammenfassung = r_hwas_betriebsinterner_prozess.bip_zusammenfassung,
            bip_abhaenigkeit_logistik = r_hwas_betriebsinterner_prozess.bip_abhaenigkeit_logistik,
            bip_bescheibung_abh_log = r_hwas_betriebsinterner_prozess.bip_bescheibung_abh_log,
            updated = r_hwas_betriebsinterner_prozess.updated,
            updated_by = r_hwas_betriebsinterner_prozess.updated_by
        when not matched then
        insert (
            bip_bezeichnung,
            ak3_uid,
            bip_zusammenfassung,
            bip_abhaenigkeit_logistik,
            bip_bescheibung_abh_log,
            inserted,
            inserted_by )
        values
            ( r_hwas_betriebsinterner_prozess.bip_bezeichnung,
              r_hwas_betriebsinterner_prozess.ak3_uid,
              r_hwas_betriebsinterner_prozess.bip_zusammenfassung,
              r_hwas_betriebsinterner_prozess.bip_abhaenigkeit_logistik,
              r_hwas_betriebsinterner_prozess.bip_bescheibung_abh_log,
              r_hwas_betriebsinterner_prozess.inserted,
              r_hwas_betriebsinterner_prozess.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_betriebsinterner_prozess);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_betriebsinterner_prozess in hwas_betriebsinterner_prozess%rowtype,
        piv_art                           in varchar2
    ) is
        r_hwas_betriebsinterner_prozess hwas_betriebsinterner_prozess%rowtype;

  -- fuer exceptions
        v_routine_name                  logs.routine_name%type;
        c_message                       clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_betriebsinterner_prozess.bip_bezeichnung := pir_hwas_betriebsinterner_prozess.bip_bezeichnung;
        r_hwas_betriebsinterner_prozess.ak3_uid := pir_hwas_betriebsinterner_prozess.ak3_uid;
        r_hwas_betriebsinterner_prozess.bip_zusammenfassung := pir_hwas_betriebsinterner_prozess.bip_zusammenfassung;
        r_hwas_betriebsinterner_prozess.bip_abhaenigkeit_logistik := pir_hwas_betriebsinterner_prozess.bip_abhaenigkeit_logistik;
        r_hwas_betriebsinterner_prozess.bip_bescheibung_abh_log := pir_hwas_betriebsinterner_prozess.bip_bescheibung_abh_log;
        r_hwas_betriebsinterner_prozess.updated := sysdate;
        r_hwas_betriebsinterner_prozess.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update hwas_betriebsinterner_prozess
                set
                    bip_uid = pir_hwas_betriebsinterner_prozess.bip_uid
                where
                    bip_uid = pir_hwas_betriebsinterner_prozess.bip_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_betriebsinterner_prozess := pir_hwas_betriebsinterner_prozess;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_betriebsinterner_prozess.inserted,
                    r_hwas_betriebsinterner_prozess.inserted_by
                from
                    hwas_betriebsinterner_prozess
                where
                    bip_uid = pir_hwas_betriebsinterner_prozess.bip_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_betriebsinterner_prozess.updated := sysdate;
                r_hwas_betriebsinterner_prozess.updated_by := pck_env.fv_user;
                update hwas_betriebsinterner_prozess
                set
                    row = r_hwas_betriebsinterner_prozess
                where
                    bip_uid = pir_hwas_betriebsinterner_prozess.bip_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_betriebsinterner_prozess);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_bip_uid in hwas_betriebsinterner_prozess.bip_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_bip_uid: ' || to_char(pin_bip_uid);
        delete from hwas_betriebsinterner_prozess
        where
            bip_uid = pin_bip_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_betriebsinterner_prozess! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_betriebsinterner_prozess! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_betriebsinterner_prozess_dml;
/

