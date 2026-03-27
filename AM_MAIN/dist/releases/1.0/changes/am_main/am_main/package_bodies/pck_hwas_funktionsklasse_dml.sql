-- liquibase formatted sql
-- changeset AM_MAIN:1774600106917 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_funktionsklasse_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_funktionsklasse_dml.sql:null:c9ffc23dae2d4f6042da90a59fa149aca7b813b7:create

create or replace package body am_main.pck_hwas_funktionsklasse_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_funktionsklasse%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'fkl_uid = '
                        || to_char(pir_row.fkl_uid)
                        || cv_sep
                        || ', fkl_bezeichnung = '
                        || pir_row.fkl_bezeichnung
                        || cv_sep
                        || ', fkl_beschreibung = '
                        || pir_row.fkl_beschreibung
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
                        || ', tkt_uid = '
                        || to_char(pir_row.tkt_uid)
                        || cv_sep
                        || ', fkl_kritis_relevant = '
                        || to_char(pir_row.fkl_kritis_relevant)
                        || cv_sep
                        || ', RUF_UID = '
                        || to_char(pir_row.ruf_uid)
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
            v_retval := '<table><tr><th>HWAS_FUNKTIONSKLASSE</th><th>Column</th></tr>'
                        || '<tr><td>fkl_uid</td><td>'
                        || to_char(pir_row.fkl_uid)
                        || '</td></tr>'
                        || '<tr><td>fkl_bezeichnung</td><td>'
                        || pir_row.fkl_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>fkl_beschreibung</td><td>'
                        || pir_row.fkl_beschreibung
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
                        || '<tr><td>tkt_uid</td><td>'
                        || to_char(pir_row.tkt_uid)
                        || '</td></tr>'
                        || '<tr><td>fkl_kritis_relevant</td><td>'
                        || to_char(pir_row.fkl_kritis_relevant)
                        || '</td></tr>'
                        || '<tr><td>RUF_UID</td><td>'
                        || to_char(pir_row.ruf_uid)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_funktionsklasse in out hwas_funktionsklasse%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_funktionsklasse.inserted := sysdate;
        pior_hwas_funktionsklasse.inserted_by := pck_env.fv_user;
        insert into hwas_funktionsklasse values pior_hwas_funktionsklasse returning fkl_uid into pior_hwas_funktionsklasse.fkl_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_funktionsklasse! Parameter: ' || fv_print(pir_row => pior_hwas_funktionsklasse
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_funktionsklasse in hwas_funktionsklasse%rowtype
    ) is
        r_hwas_funktionsklasse hwas_funktionsklasse%rowtype;

  -- fuer exceptions
        v_routine_name         logs.routine_name%type;
        c_message              clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_funktionsklasse := pir_hwas_funktionsklasse;
        r_hwas_funktionsklasse.inserted := sysdate;
        r_hwas_funktionsklasse.updated := sysdate;
        r_hwas_funktionsklasse.inserted_by := pck_env.fv_user;
        r_hwas_funktionsklasse.updated_by := pck_env.fv_user;
        merge into hwas_funktionsklasse
        using dual on ( fkl_uid = r_hwas_funktionsklasse.fkl_uid )
        when matched then update
        set fkl_bezeichnung = r_hwas_funktionsklasse.fkl_bezeichnung,
            fkl_beschreibung = r_hwas_funktionsklasse.fkl_beschreibung,
            updated = r_hwas_funktionsklasse.updated,
            updated_by = r_hwas_funktionsklasse.updated_by,
            tkt_uid = r_hwas_funktionsklasse.tkt_uid,
            fkl_kritis_relevant = r_hwas_funktionsklasse.fkl_kritis_relevant,
            ruf_uid = r_hwas_funktionsklasse.ruf_uid
        when not matched then
        insert (
            fkl_bezeichnung,
            fkl_beschreibung,
            inserted,
            inserted_by,
            tkt_uid,
            fkl_kritis_relevant,
            ruf_uid )
        values
            ( r_hwas_funktionsklasse.fkl_bezeichnung,
              r_hwas_funktionsklasse.fkl_beschreibung,
              r_hwas_funktionsklasse.inserted,
              r_hwas_funktionsklasse.inserted_by,
              r_hwas_funktionsklasse.tkt_uid,
              r_hwas_funktionsklasse.fkl_kritis_relevant,
              r_hwas_funktionsklasse.ruf_uid );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_funktionsklasse);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_funktionsklasse in hwas_funktionsklasse%rowtype,
        piv_art                  in varchar2
    ) is
        r_hwas_funktionsklasse hwas_funktionsklasse%rowtype;        

-- fuer exceptions        
        v_routine_name         logs.routine_name%type;
        c_message              clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_funktionsklasse := pir_hwas_funktionsklasse;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_funktionsklasse.inserted,
                    r_hwas_funktionsklasse.inserted_by
                from
                    hwas_funktionsklasse
                where
                    fkl_uid = pir_hwas_funktionsklasse.fkl_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_funktionsklasse.updated := sysdate;
                r_hwas_funktionsklasse.updated_by := pck_env.fv_user;
                update hwas_funktionsklasse
                set
                    row = r_hwas_funktionsklasse
                where
                    fkl_uid = pir_hwas_funktionsklasse.fkl_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_funktionsklasse);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_fkl_uid in hwas_funktionsklasse.fkl_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_fkl_uid: ' || to_char(pin_fkl_uid);
        delete from hwas_funktionsklasse
        where
            fkl_uid = pin_fkl_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_funktionsklasse! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_funktionsklasse! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_funktionsklasse_dml;
/

