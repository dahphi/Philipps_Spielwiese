-- liquibase formatted sql
-- changeset AM_MAIN:1774600103223 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_anlagenkategorie_e3_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_anlagenkategorie_e3_dml.sql:null:b0c34c893bb0ea114b967ff1bbabaa1ced983487:create

create or replace package body am_main.pck_hwas_anlagenkategorie_e3_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_anlagenkategorie_e3%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ak3_uid = '
                        || to_char(pir_row.ak3_uid)
                        || cv_sep
                        || ', ak3_beschreibung = '
                        || pir_row.ak3_beschreibung
                        || cv_sep
                        || ', ak3_bemessungskriterium = '
                        || pir_row.ak3_bemessungskriterium
                        || cv_sep
                        || ', ak3_schwellwert = '
                        || pir_row.ak3_schwellwert
                        || cv_sep
                        || ', be2_uid = '
                        || to_char(pir_row.be2_uid)
                        || cv_sep
                        || ', ak3_nummer = '
                        || to_char(pir_row.ak3_nummer)
                        || cv_sep
                        || ', ak3_nc_implementierung = '
                        || pir_row.ak3_nc_implementierung
                        || cv_sep
                        || ', ak3_nc_bezeichnung = '
                        || pir_row.ak3_nc_bezeichnung
                        || cv_sep
                        || ', ak3_definition = '
                        || pir_row.ak3_definition
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
                        || ', ak3_versorgungsgrad = '
                        || to_char(pir_row.ak3_versorgungsgrad)
                        || cv_sep
                        || ', ak3_schwellenwert_ueberschritten = '
                        || to_char(pir_row.ak3_schwellenwert_ueberschritten)
                        || cv_sep
                        || ', ak3_dataenquelle_vg = '
                        || pir_row.ak3_dataenquelle_vg
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
            v_retval := '<table><tr><th>HWAS_ANLAGENKATEGORIE_E3</th><th>Column</th></tr>'
                        || '<tr><td>ak3_uid</td><td>'
                        || to_char(pir_row.ak3_uid)
                        || '</td></tr>'
                        || '<tr><td>ak3_beschreibung</td><td>'
                        || pir_row.ak3_beschreibung
                        || '</td></tr>'
                        || '<tr><td>ak3_bemessungskriterium</td><td>'
                        || pir_row.ak3_bemessungskriterium
                        || '</td></tr>'
                        || '<tr><td>ak3_schwellwert</td><td>'
                        || pir_row.ak3_schwellwert
                        || '</td></tr>'
                        || '<tr><td>be2_uid</td><td>'
                        || to_char(pir_row.be2_uid)
                        || '</td></tr>'
                        || '<tr><td>ak3_nummer</td><td>'
                        || to_char(pir_row.ak3_nummer)
                        || '</td></tr>'
                        || '<tr><td>ak3_nc_implementierung</td><td>'
                        || pir_row.ak3_nc_implementierung
                        || '</td></tr>'
                        || '<tr><td>ak3_nc_bezeichnung</td><td>'
                        || pir_row.ak3_nc_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>ak3_definition</td><td>'
                        || pir_row.ak3_definition
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
                        || '<tr><td>ak3_versorgungsgrad</td><td>'
                        || to_char(pir_row.ak3_versorgungsgrad)
                        || '</td></tr>'
                        || '<tr><td>ak3_schwellenwert_ueberschritten</td><td>'
                        || to_char(pir_row.ak3_schwellenwert_ueberschritten)
                        || '</td></tr>'
                        || '<tr><td>ak3_dataenquelle_vg</td><td>'
                        || pir_row.ak3_dataenquelle_vg
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_hwas_anlagenkategorie_e3 in out hwas_anlagenkategorie_e3%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_anlagenkategorie_e3.inserted := sysdate;
        pior_hwas_anlagenkategorie_e3.inserted_by := pck_env.fv_user;
        insert into hwas_anlagenkategorie_e3 values pior_hwas_anlagenkategorie_e3 returning ak3_uid into pior_hwas_anlagenkategorie_e3.ak3_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_anlagenkategorie_e3! Parameter: ' || fv_print(pir_row => pior_hwas_anlagenkategorie_e3
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_anlagenkategorie_e3 in hwas_anlagenkategorie_e3%rowtype
    ) is
        r_hwas_anlagenkategorie_e3 hwas_anlagenkategorie_e3%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_anlagenkategorie_e3 := pir_hwas_anlagenkategorie_e3;
        r_hwas_anlagenkategorie_e3.inserted := sysdate;
        r_hwas_anlagenkategorie_e3.updated := sysdate;
        r_hwas_anlagenkategorie_e3.inserted_by := pck_env.fv_user;
        r_hwas_anlagenkategorie_e3.updated_by := pck_env.fv_user;
        merge into hwas_anlagenkategorie_e3
        using dual on ( ak3_uid = r_hwas_anlagenkategorie_e3.ak3_uid )
        when matched then update
        set ak3_beschreibung = r_hwas_anlagenkategorie_e3.ak3_beschreibung,
            ak3_bemessungskriterium = r_hwas_anlagenkategorie_e3.ak3_bemessungskriterium,
            ak3_schwellwert = r_hwas_anlagenkategorie_e3.ak3_schwellwert,
            be2_uid = r_hwas_anlagenkategorie_e3.be2_uid,
            ak3_nummer = r_hwas_anlagenkategorie_e3.ak3_nummer,
            ak3_nc_implementierung = r_hwas_anlagenkategorie_e3.ak3_nc_implementierung,
            ak3_nc_bezeichnung = r_hwas_anlagenkategorie_e3.ak3_nc_bezeichnung,
            ak3_definition = r_hwas_anlagenkategorie_e3.ak3_definition,
            updated = r_hwas_anlagenkategorie_e3.updated,
            updated_by = r_hwas_anlagenkategorie_e3.updated_by,
            ak3_versorgungsgrad = r_hwas_anlagenkategorie_e3.ak3_versorgungsgrad,
            ak3_schwellenwert_ueberschritten = r_hwas_anlagenkategorie_e3.ak3_schwellenwert_ueberschritten,
            ak3_dataenquelle_vg = r_hwas_anlagenkategorie_e3.ak3_dataenquelle_vg
        when not matched then
        insert (
            ak3_beschreibung,
            ak3_bemessungskriterium,
            ak3_schwellwert,
            be2_uid,
            ak3_nummer,
            ak3_nc_implementierung,
            ak3_nc_bezeichnung,
            ak3_definition,
            inserted,
            inserted_by,
            ak3_versorgungsgrad,
            ak3_schwellenwert_ueberschritten,
            ak3_dataenquelle_vg )
        values
            ( r_hwas_anlagenkategorie_e3.ak3_beschreibung,
              r_hwas_anlagenkategorie_e3.ak3_bemessungskriterium,
              r_hwas_anlagenkategorie_e3.ak3_schwellwert,
              r_hwas_anlagenkategorie_e3.be2_uid,
              r_hwas_anlagenkategorie_e3.ak3_nummer,
              r_hwas_anlagenkategorie_e3.ak3_nc_implementierung,
              r_hwas_anlagenkategorie_e3.ak3_nc_bezeichnung,
              r_hwas_anlagenkategorie_e3.ak3_definition,
              r_hwas_anlagenkategorie_e3.inserted,
              r_hwas_anlagenkategorie_e3.inserted_by,
              r_hwas_anlagenkategorie_e3.ak3_versorgungsgrad,
              r_hwas_anlagenkategorie_e3.ak3_schwellenwert_ueberschritten,
              r_hwas_anlagenkategorie_e3.ak3_dataenquelle_vg );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_anlagenkategorie_e3);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------
/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_anlagenkategorie_e3 in hwas_anlagenkategorie_e3%rowtype,
        piv_art                      in varchar2
    ) is
        r_hwas_anlagenkategorie_e3 hwas_anlagenkategorie_e3%rowtype;        

-- fuer exceptions        
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_anlagenkategorie_e3 := pir_hwas_anlagenkategorie_e3;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_anlagenkategorie_e3.inserted,
                    r_hwas_anlagenkategorie_e3.inserted_by
                from
                    hwas_anlagenkategorie_e3
                where
                    ak3_uid = pir_hwas_anlagenkategorie_e3.ak3_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_anlagenkategorie_e3.updated := sysdate;
                r_hwas_anlagenkategorie_e3.updated_by := pck_env.fv_user;
                update hwas_anlagenkategorie_e3
                set
                    row = r_hwas_anlagenkategorie_e3
                where
                    ak3_uid = pir_hwas_anlagenkategorie_e3.ak3_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_anlagenkategorie_e3);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ak3_uid in hwas_anlagenkategorie_e3.ak3_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ak3_uid: ' || to_char(pin_ak3_uid);
        delete from hwas_anlagenkategorie_e3
        where
            ak3_uid = pin_ak3_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_anlagenkategorie_e3! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_anlagenkategorie_e3! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

---------------------------------------------------------------------------------------------------

end pck_hwas_anlagenkategorie_e3_dml;
/

