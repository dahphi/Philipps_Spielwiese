-- liquibase formatted sql
-- changeset AM_MAIN:1774600111376 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_informationscluster_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_informationscluster_dml.sql:null:cdbb3a6f5d7e9eb2d6ce5e0a10342c84a527f557:create

create or replace package body am_main.pck_hwas_informationscluster_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------
    function fv_print (
        pir_row         in hwas_informationscluster%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'INCL_UID = '
                        || to_char(pir_row.incl_uid)
                        || cv_sep
                        || ', INCL_BEZEICHNUNG = '
                        || pir_row.incl_bezeichnung
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
            v_retval := '<table><tr><th>HWAS_INFORMATIONSCLUSTER</th><th>Column</th></tr>'
                        || '<tr><td>INCL_UID</td><td>'
                        || to_char(pir_row.incl_uid)
                        || '</td></tr>'
                        || '<tr><td>INCL_BEZEICHNUNG</td><td>'
                        || pir_row.incl_bezeichnung
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
        pior_hwas_informationscluster in out hwas_informationscluster%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_informationscluster.inserted := sysdate;
        pior_hwas_informationscluster.inserted_by := pck_env.fv_user;
        insert into hwas_informationscluster values pior_hwas_informationscluster returning incl_uid into pior_hwas_informationscluster.incl_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle HWAS_INFORMATIONSCLUSTER! Parameter: ' || fv_print(pir_row => pior_hwas_informationscluster
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_informationscluster in hwas_informationscluster%rowtype
    ) is
        r_hwas_informationscluster hwas_informationscluster%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_informationscluster := pir_hwas_informationscluster;
        r_hwas_informationscluster.inserted := sysdate;
        r_hwas_informationscluster.updated := sysdate;
        r_hwas_informationscluster.inserted_by := pck_env.fv_user;
        r_hwas_informationscluster.updated_by := pck_env.fv_user;
        merge into hwas_informationscluster
        using dual on ( incl_uid = r_hwas_informationscluster.incl_uid )
        when matched then update
        set incl_bezeichnung = r_hwas_informationscluster.incl_bezeichnung,
            incl_beschreibung = r_hwas_informationscluster.incl_beschreibung,
            vet_lfd_nr = r_hwas_informationscluster.vet_lfd_nr,
            vef_lfd_nr = r_hwas_informationscluster.vef_lfd_nr,
            int_lfd_nr = r_hwas_informationscluster.int_lfd_nr,
            aut_lfd_nr = r_hwas_informationscluster.aut_lfd_nr,
            data_owner = r_hwas_informationscluster.data_owner,
            dom_uid_fk = r_hwas_informationscluster.dom_uid_fk,
            updated = r_hwas_informationscluster.updated,
            updated_by = r_hwas_informationscluster.updated_by,
            incl_typ = r_hwas_informationscluster.incl_typ
        when not matched then
        insert (
            incl_bezeichnung,
            incl_beschreibung,
            vet_lfd_nr,
            vef_lfd_nr,
            int_lfd_nr,
            aut_lfd_nr,
            inserted,
            inserted_by,
            data_owner,
            dom_uid_fk,
            incl_typ )
        values
            ( r_hwas_informationscluster.incl_bezeichnung,
              r_hwas_informationscluster.incl_beschreibung,
              r_hwas_informationscluster.vet_lfd_nr,
              r_hwas_informationscluster.vef_lfd_nr,
              r_hwas_informationscluster.int_lfd_nr,
              r_hwas_informationscluster.aut_lfd_nr,
              r_hwas_informationscluster.inserted,
              r_hwas_informationscluster.inserted_by,
              r_hwas_informationscluster.data_owner,
              r_hwas_informationscluster.dom_uid_fk,
              r_hwas_informationscluster.incl_typ );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_informationscluster);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_informationscluster in hwas_informationscluster%rowtype,
        piv_art                      in varchar2
    ) is
        r_hwas_informationscluster hwas_informationscluster%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_hwas_informationscluster.incl_bezeichnung := pir_hwas_informationscluster.incl_bezeichnung;
        r_hwas_informationscluster.incl_beschreibung := pir_hwas_informationscluster.incl_beschreibung;
        r_hwas_informationscluster.vet_lfd_nr := pir_hwas_informationscluster.vet_lfd_nr;
        r_hwas_informationscluster.vef_lfd_nr := pir_hwas_informationscluster.vef_lfd_nr;
        r_hwas_informationscluster.int_lfd_nr := pir_hwas_informationscluster.int_lfd_nr;
        r_hwas_informationscluster.aut_lfd_nr := pir_hwas_informationscluster.aut_lfd_nr;
        r_hwas_informationscluster.data_owner := pir_hwas_informationscluster.data_owner;
        r_hwas_informationscluster.dom_uid_fk := pir_hwas_informationscluster.dom_uid_fk;
        r_hwas_informationscluster.updated := sysdate;
        r_hwas_informationscluster.updated_by := pck_env.fv_user;
        r_hwas_informationscluster.incl_typ := pir_hwas_informationscluster.incl_typ;
        case piv_art
            when '<replace>' then
                update hwas_informationscluster
                set
                    incl_uid = pir_hwas_informationscluster.incl_uid
                where
                    incl_uid = pir_hwas_informationscluster.incl_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_informationscluster := pir_hwas_informationscluster;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_informationscluster.inserted,
                    r_hwas_informationscluster.inserted_by
                from
                    hwas_informationscluster
                where
                    incl_uid = pir_hwas_informationscluster.incl_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_informationscluster.updated := sysdate;
                r_hwas_informationscluster.updated_by := pck_env.fv_user;
                update hwas_informationscluster
                set
                    row = r_hwas_informationscluster
                where
                    incl_uid = pir_hwas_informationscluster.incl_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_informationscluster);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_incl_uid in hwas_informationscluster.incl_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_INCL_UID: ' || to_char(pin_incl_uid);
        delete from hwas_informationscluster
        where
            incl_uid = pin_incl_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle HWAS_INFORMATIONSCLUSTER! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle HWAS_INFORMATIONSCLUSTER! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_informationscluster_dml;
/

