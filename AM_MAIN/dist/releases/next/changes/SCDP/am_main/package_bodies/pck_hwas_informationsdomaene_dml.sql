-- liquibase formatted sql
-- changeset AM_MAIN:1774557117850 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_informationsdomaene_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_informationsdomaene_dml.sql:null:40c7b75cfd4626178b54816fec52bd86cd64cc47:create

create or replace package body am_main.pck_hwas_informationsdomaene_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_informationsdomaene%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'DOM_UID = '
                        || to_char(pir_row.dom_uid)
                        || cv_sep
                        || ', DOMAENE = '
                        || pir_row.domaene
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
            v_retval := '<table><tr><th>HWAS_INFORMATIONSDOMAENE</th><th>Column</th></tr>'
                        || '<tr><td>DOM_UID</td><td>'
                        || to_char(pir_row.dom_uid)
                        || '</td></tr>'
                        || '<tr><td>DOMAENE</td><td>'
                        || pir_row.domaene
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
        pior_hwas_informationsdomaene in out hwas_informationsdomaene%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_informationsdomaene.inserted := sysdate;
        pior_hwas_informationsdomaene.inserted_by := pck_env.fv_user;
        insert into hwas_informationsdomaene values pior_hwas_informationsdomaene returning dom_uid into pior_hwas_informationsdomaene.dom_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle HWAS_INFORMATIONSDOMAENE! Parameter: ' || fv_print(pir_row => pior_hwas_informationsdomaene
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_informationsdomaene in hwas_informationsdomaene%rowtype
    ) is
        r_hwas_informationsdomaene hwas_informationsdomaene%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_informationsdomaene := pir_hwas_informationsdomaene;
        r_hwas_informationsdomaene.inserted := sysdate;
        r_hwas_informationsdomaene.updated := sysdate;
        r_hwas_informationsdomaene.inserted_by := pck_env.fv_user;
        r_hwas_informationsdomaene.updated_by := pck_env.fv_user;
        merge into hwas_informationsdomaene
        using dual on ( dom_uid = r_hwas_informationsdomaene.dom_uid )
        when matched then update
        set domaene = r_hwas_informationsdomaene.domaene,
            beschreibung = r_hwas_informationsdomaene.beschreibung,
            updated = r_hwas_informationsdomaene.updated,
            updated_by = r_hwas_informationsdomaene.updated_by
        when not matched then
        insert (
            domaene,
            beschreibung,
            inserted,
            inserted_by )
        values
            ( r_hwas_informationsdomaene.domaene,
              r_hwas_informationsdomaene.beschreibung,
              r_hwas_informationsdomaene.inserted,
              r_hwas_informationsdomaene.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_informationsdomaene);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_informationsdomaene in hwas_informationsdomaene%rowtype,
        piv_art                      in varchar2
    ) is
        r_hwas_informationsdomaene hwas_informationsdomaene%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_informationsdomaene.domaene := pir_hwas_informationsdomaene.domaene;
        r_hwas_informationsdomaene.beschreibung := pir_hwas_informationsdomaene.beschreibung;
        r_hwas_informationsdomaene.updated := sysdate;
        r_hwas_informationsdomaene.updated_by := pck_env.fv_user;
        case piv_art
            when '<replace>' then
                update hwas_informationsdomaene
                set
                    dom_uid = pir_hwas_informationsdomaene.dom_uid
                where
                    dom_uid = pir_hwas_informationsdomaene.dom_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_informationsdomaene := pir_hwas_informationsdomaene;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_informationsdomaene.inserted,
                    r_hwas_informationsdomaene.inserted_by
                from
                    hwas_informationsdomaene
                where
                    dom_uid = pir_hwas_informationsdomaene.dom_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_informationsdomaene.updated := sysdate;
                r_hwas_informationsdomaene.updated_by := pck_env.fv_user;
                update hwas_informationsdomaene
                set
                    row = r_hwas_informationsdomaene
                where
                    dom_uid = pir_hwas_informationsdomaene.dom_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_informationsdomaene);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_dom_uid in hwas_informationsdomaene.dom_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_DOM_UID: ' || to_char(pin_dom_uid);
        delete from hwas_informationsdomaene
        where
            dom_uid = pin_dom_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle HWAS_INFORMATIONSDOMAENE! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle HWAS_INFORMATIONSDOMAENE! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_informationsdomaene_dml;
/

