-- liquibase formatted sql
-- changeset AM_MAIN:1774600115008 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_netzebene_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_netzebene_dml.sql:null:823ccc0d57bc2cdc7978b00dd61073c32c82ed0c:create

create or replace package body am_main.pck_hwas_netzebene_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_netzebene%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ne_uid = '
                        || to_char(pir_row.ne_uid)
                        || cv_sep
                        || ', ne_bezeichnung = '
                        || pir_row.ne_bezeichnung
                        || cv_sep
                        || ', ne_beschreibung = '
                        || pir_row.ne_beschreibung
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
            v_retval := '<table><tr><th>HWAS_NETZEBENE</th><th>Column</th></tr>'
                        || '<tr><td>ne_uid</td><td>'
                        || to_char(pir_row.ne_uid)
                        || '</td></tr>'
                        || '<tr><td>ne_bezeichnung</td><td>'
                        || pir_row.ne_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>ne_beschreibung</td><td>'
                        || pir_row.ne_beschreibung
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
        pior_hwas_netzebene in out hwas_netzebene%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_netzebene.inserted := sysdate;
        pior_hwas_netzebene.inserted_by := pck_env.fv_user;
        insert into hwas_netzebene values pior_hwas_netzebene returning ne_uid into pior_hwas_netzebene.ne_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_netzebene! Parameter: ' || fv_print(pir_row => pior_hwas_netzebene);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_netzebene in hwas_netzebene%rowtype
    ) is
        r_hwas_netzebene hwas_netzebene%rowtype;

  -- fuer exceptions
        v_routine_name   logs.routine_name%type;
        c_message        clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_netzebene := pir_hwas_netzebene;
        r_hwas_netzebene.inserted := sysdate;
        r_hwas_netzebene.updated := sysdate;
        r_hwas_netzebene.inserted_by := pck_env.fv_user;
        r_hwas_netzebene.updated_by := pck_env.fv_user;
        merge into hwas_netzebene
        using dual on ( ne_uid = r_hwas_netzebene.ne_uid )
        when matched then update
        set ne_bezeichnung = r_hwas_netzebene.ne_bezeichnung,
            ne_beschreibung = r_hwas_netzebene.ne_beschreibung,
            updated = r_hwas_netzebene.updated,
            updated_by = r_hwas_netzebene.updated_by
        when not matched then
        insert (
            ne_bezeichnung,
            ne_beschreibung,
            inserted,
            inserted_by )
        values
            ( r_hwas_netzebene.ne_bezeichnung,
              r_hwas_netzebene.ne_beschreibung,
              r_hwas_netzebene.inserted,
              r_hwas_netzebene.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_netzebene);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_netzebene in hwas_netzebene%rowtype,
        piv_art            in varchar2
    ) is
        r_hwas_netzebene hwas_netzebene%rowtype;        

-- fuer exceptions        
        v_routine_name   logs.routine_name%type;
        c_message        clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Ã?bernehmen der Eingabedaten  
                r_hwas_netzebene := pir_hwas_netzebene;  
      -- ErgÃ¤nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_netzebene.inserted,
                    r_hwas_netzebene.inserted_by
                from
                    hwas_netzebene
                where
                    ne_uid = pir_hwas_netzebene.ne_uid;  
      -- ErgÃ¤nzen der Update-Daten  
                r_hwas_netzebene.updated := sysdate;
                r_hwas_netzebene.updated_by := pck_env.fv_user;
                update hwas_netzebene
                set
                    row = r_hwas_netzebene
                where
                    ne_uid = pir_hwas_netzebene.ne_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_netzebene);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ne_uid in hwas_netzebene.ne_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ne_uid: ' || to_char(pin_ne_uid);
        delete from hwas_netzebene
        where
            ne_uid = pin_ne_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_netzebene! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_netzebene! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_netzebene_dml;
/

