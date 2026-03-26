-- liquibase formatted sql
-- changeset AM_MAIN:1774556570381 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_modell_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_modell_dml.sql:null:b584e62751e37d8ff2cf5e2719162d1326f7f27e:create

create or replace package body am_main.pck_hwas_modell_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_modell%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'mdl_uid = '
                        || to_char(pir_row.mdl_uid)
                        || cv_sep
                        || ', mdl_bezeichnung = '
                        || pir_row.mdl_bezeichnung
                        || cv_sep
                        || ', mdl_anzahl_systeme = '
                        || to_char(pir_row.mdl_anzahl_systeme)
                        || cv_sep
                        || ', mdl_tn_je_system = '
                        || to_char(pir_row.mdl_tn_je_system)
                        || cv_sep
                        || ', mdl_grund_tn_je_system = '
                        || pir_row.mdl_grund_tn_je_system
                        || cv_sep
                        || ', mdl_regel = '
                        || pir_row.mdl_regel
                        || cv_sep
                        || ', hst_uid = '
                        || to_char(pir_row.hst_uid)
                        || cv_sep
                        || ', gkl_uid = '
                        || to_char(pir_row.gkl_uid)
                        || cv_sep
                        || ', fkl_uid = '
                        || to_char(pir_row.fkl_uid)
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
            v_retval := '<table><tr><th>HWAS_MODELL</th><th>Column</th></tr>'
                        || '<tr><td>mdl_uid</td><td>'
                        || to_char(pir_row.mdl_uid)
                        || '</td></tr>'
                        || '<tr><td>mdl_bezeichnung</td><td>'
                        || pir_row.mdl_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>mdl_anzahl_systeme</td><td>'
                        || to_char(pir_row.mdl_anzahl_systeme)
                        || '</td></tr>'
                        || '<tr><td>mdl_tn_je_system</td><td>'
                        || to_char(pir_row.mdl_tn_je_system)
                        || '</td></tr>'
                        || '<tr><td>mdl_grund_tn_je_system</td><td>'
                        || pir_row.mdl_grund_tn_je_system
                        || '</td></tr>'
                        || '<tr><td>mdl_regel</td><td>'
                        || pir_row.mdl_regel
                        || '</td></tr>'
                        || '<tr><td>hst_uid</td><td>'
                        || to_char(pir_row.hst_uid)
                        || '</td></tr>'
                        || '<tr><td>gkl_uid</td><td>'
                        || to_char(pir_row.gkl_uid)
                        || '</td></tr>'
                        || '<tr><td>fkl_uid</td><td>'
                        || to_char(pir_row.fkl_uid)
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
        pior_hwas_modell in out hwas_modell%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_modell.inserted := sysdate;
        pior_hwas_modell.inserted_by := pck_env.fv_user;
        insert into hwas_modell values pior_hwas_modell returning mdl_uid into pior_hwas_modell.mdl_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle hwas_modell! Parameter: ' || fv_print(pir_row => pior_hwas_modell);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_modell in hwas_modell%rowtype
    ) is
        r_hwas_modell  hwas_modell%rowtype;

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_modell := pir_hwas_modell;
        r_hwas_modell.inserted := sysdate;
        r_hwas_modell.updated := sysdate;
        r_hwas_modell.inserted_by := pck_env.fv_user;
        r_hwas_modell.updated_by := pck_env.fv_user;
        merge into hwas_modell
        using dual on ( mdl_uid = r_hwas_modell.mdl_uid )
        when matched then update
        set mdl_bezeichnung = r_hwas_modell.mdl_bezeichnung,
            mdl_anzahl_systeme = r_hwas_modell.mdl_anzahl_systeme,
            mdl_tn_je_system = r_hwas_modell.mdl_tn_je_system,
            mdl_grund_tn_je_system = r_hwas_modell.mdl_grund_tn_je_system,
            mdl_regel = r_hwas_modell.mdl_regel,
            hst_uid = r_hwas_modell.hst_uid,
            gkl_uid = r_hwas_modell.gkl_uid,
            fkl_uid = r_hwas_modell.fkl_uid,
            updated = r_hwas_modell.updated,
            updated_by = r_hwas_modell.updated_by
        when not matched then
        insert (
            mdl_bezeichnung,
            mdl_anzahl_systeme,
            mdl_tn_je_system,
            mdl_grund_tn_je_system,
            mdl_regel,
            hst_uid,
            gkl_uid,
            fkl_uid,
            inserted,
            inserted_by )
        values
            ( r_hwas_modell.mdl_bezeichnung,
              r_hwas_modell.mdl_anzahl_systeme,
              r_hwas_modell.mdl_tn_je_system,
              r_hwas_modell.mdl_grund_tn_je_system,
              r_hwas_modell.mdl_regel,
              r_hwas_modell.hst_uid,
              r_hwas_modell.gkl_uid,
              r_hwas_modell.fkl_uid,
              r_hwas_modell.inserted,
              r_hwas_modell.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_modell);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_hwas_modell in hwas_modell%rowtype,
        piv_art         in varchar2
    ) is
        r_hwas_modell  hwas_modell%rowtype;        

-- fuer exceptions        
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Ã?bernehmen der Eingabedaten  
                r_hwas_modell := pir_hwas_modell;  
      -- ErgÃ¤nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_modell.inserted,
                    r_hwas_modell.inserted_by
                from
                    hwas_modell
                where
                    mdl_uid = pir_hwas_modell.mdl_uid;  
      -- ErgÃ¤nzen der Update-Daten  
                r_hwas_modell.updated := sysdate;
                r_hwas_modell.updated_by := pck_env.fv_user;
                update hwas_modell
                set
                    row = r_hwas_modell
                where
                    mdl_uid = pir_hwas_modell.mdl_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_modell);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        
---------------------------------------------------------------------------------------------------

    procedure p_insert_hwdb_modell is

  -- fuer exceptions
        v_routine_name       logs.routine_name%type;
        c_message            clob;
        v_hersteller_uid     number;
        r_hwdb_modell_import hwas_modell%rowtype;
        cursor c_neues_modell is
        select distinct
            hersteller,
            modell
        from
            am_int.hwdb_hosts
        where
            modell in (
                select
                    modell
                from
                    am_int.hwdb_hosts
                minus
                select
                    mdl_bezeichnung
                from
                    hwas_modell
            );

    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_hwdb_modell_import.inserted := sysdate;
        r_hwdb_modell_import.inserted_by := pck_env.fv_user;
        for i in c_neues_modell loop
            select distinct
                hst_uid
            into v_hersteller_uid
            from
                hwas_hersteller
            where
                hst_bezeichnung = i.hersteller;

            r_hwdb_modell_import.mdl_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_hwdb_modell_import.mdl_bezeichnung := i.modell;
            r_hwdb_modell_import.mdl_regel := 'aus HWDB';
            r_hwdb_modell_import.hst_uid := v_hersteller_uid;
    --dbms_output.put_line( i.MODELL ||' - '||v_hersteller_uid);

            insert into hwas_modell values r_hwdb_modell_import;

        end loop;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle hwas_modell! Parameter: ' || fv_print( pir_row => pior_hwas_modell );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert_hwdb_modell;
---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_mdl_uid in hwas_modell.mdl_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_mdl_uid: ' || to_char(pin_mdl_uid);
        delete from hwas_modell
        where
            mdl_uid = pin_mdl_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle hwas_modell! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle hwas_modell! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_modell_dml;
/

