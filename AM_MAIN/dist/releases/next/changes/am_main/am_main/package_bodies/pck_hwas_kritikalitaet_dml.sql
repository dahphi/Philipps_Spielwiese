-- liquibase formatted sql
-- changeset AM_MAIN:1774600113123 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_kritikalitaet_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_kritikalitaet_dml.sql:null:5255c03d1a4736663d3336c738d23a4b707be0f7:create

create or replace package body am_main.pck_hwas_kritikalitaet_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_kritikalitaet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'krk_uid = '
                        || to_char(pir_row.krk_uid)
                        || cv_sep
                        || ', krk_bezeichnung = '
                        || pir_row.krk_bezeichnung
                        || cv_sep
                        || ', krk_kurzbeschreibung = '
                        || pir_row.krk_kurzbeschreibung
                        || cv_sep
                        || ', krk_erlaeuterungen = '
                        || pir_row.krk_erlaeuterungen
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
            v_retval := '<table><tr><th>HWAS_KRITIKALITAET</th><th>Column</th></tr>'
                        || '<tr><td>krk_uid</td><td>'
                        || to_char(pir_row.krk_uid)
                        || '</td></tr>'
                        || '<tr><td>krk_bezeichnung</td><td>'
                        || pir_row.krk_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>krk_kurzbeschreibung</td><td>'
                        || pir_row.krk_kurzbeschreibung
                        || '</td></tr>'
                        || '<tr><td>krk_erlaeuterungen</td><td>'
                        || pir_row.krk_erlaeuterungen
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
        pior_hwas_kritikalitaet in out hwas_kritikalitaet%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_kritikalitaet.inserted := sysdate;
        pior_hwas_kritikalitaet.inserted_by := pck_env.fv_user;
        insert into hwas_kritikalitaet values pior_hwas_kritikalitaet returning krk_uid into pior_hwas_kritikalitaet.krk_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_kritikalitaet! Parameter: ' || fv_print(pir_row => pior_hwas_kritikalitaet
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_kritikalitaet in hwas_kritikalitaet%rowtype
    ) is
        r_hwas_kritikalitaet hwas_kritikalitaet%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_kritikalitaet := pir_hwas_kritikalitaet;
        r_hwas_kritikalitaet.inserted := sysdate;
        r_hwas_kritikalitaet.updated := sysdate;
        r_hwas_kritikalitaet.inserted_by := pck_env.fv_user;
        r_hwas_kritikalitaet.updated_by := pck_env.fv_user;
        merge into hwas_kritikalitaet
        using dual on ( krk_uid = r_hwas_kritikalitaet.krk_uid )
        when matched then update
        set krk_bezeichnung = r_hwas_kritikalitaet.krk_bezeichnung,
            krk_kurzbeschreibung = r_hwas_kritikalitaet.krk_kurzbeschreibung,
            krk_erlaeuterungen = r_hwas_kritikalitaet.krk_erlaeuterungen,
            updated = r_hwas_kritikalitaet.updated,
            updated_by = r_hwas_kritikalitaet.updated_by
        when not matched then
        insert (
            krk_bezeichnung,
            krk_kurzbeschreibung,
            krk_erlaeuterungen,
            inserted,
            inserted_by )
        values
            ( r_hwas_kritikalitaet.krk_bezeichnung,
              r_hwas_kritikalitaet.krk_kurzbeschreibung,
              r_hwas_kritikalitaet.krk_erlaeuterungen,
              r_hwas_kritikalitaet.inserted,
              r_hwas_kritikalitaet.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_kritikalitaet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_kritikalitaet in hwas_kritikalitaet%rowtype,
        piv_art                in varchar2
    ) is
        r_hwas_kritikalitaet hwas_kritikalitaet%rowtype;

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_kritikalitaet.krk_bezeichnung := pir_hwas_kritikalitaet.krk_bezeichnung;
        r_hwas_kritikalitaet.krk_kurzbeschreibung := pir_hwas_kritikalitaet.krk_kurzbeschreibung;
        r_hwas_kritikalitaet.krk_erlaeuterungen := pir_hwas_kritikalitaet.krk_erlaeuterungen;
        r_hwas_kritikalitaet.updated := sysdate;
        r_hwas_kritikalitaet.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update hwas_kritikalitaet
                set
                    krk_uid = pir_hwas_kritikalitaet.krk_uid
                where
                    krk_uid = pir_hwas_kritikalitaet.krk_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_kritikalitaet := pir_hwas_kritikalitaet;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_kritikalitaet.inserted,
                    r_hwas_kritikalitaet.inserted_by
                from
                    hwas_kritikalitaet
                where
                    krk_uid = pir_hwas_kritikalitaet.krk_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_kritikalitaet.updated := sysdate;
                r_hwas_kritikalitaet.updated_by := pck_env.fv_user;
                update hwas_kritikalitaet
                set
                    row = r_hwas_kritikalitaet
                where
                    krk_uid = pir_hwas_kritikalitaet.krk_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_kritikalitaet);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_krk_uid in hwas_kritikalitaet.krk_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_krk_uid: ' || to_char(pin_krk_uid);
        delete from hwas_kritikalitaet
        where
            krk_uid = pin_krk_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_kritikalitaet! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_kritikalitaet! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_kritikalitaet_dml;
/

