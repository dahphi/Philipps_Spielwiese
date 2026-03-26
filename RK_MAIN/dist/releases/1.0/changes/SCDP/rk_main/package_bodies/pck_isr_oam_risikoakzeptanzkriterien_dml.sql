-- liquibase formatted sql
-- changeset RK_MAIN:1774561693236 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_oam_risikoakzeptanzkriterien_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_oam_risikoakzeptanzkriterien_dml.sql:null:9dbac39a48277e0765f09be76f27715d3ba463f4:create

create or replace package body rk_main.pck_isr_oam_risikoakzeptanzkriterien_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_risikoakzeptanzkriterien%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'rak_uid = '
                        || to_char(pir_row.rak_uid)
                        || cv_sep
                        || ', rak_bezeichnung = '
                        || pir_row.rak_bezeichnung
                        || cv_sep
                        || ', rak_wert = '
                        || to_char(pir_row.rak_wert)
                        || cv_sep
                        || ', rak_beschreibung = '
                        || pir_row.rak_beschreibung
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
            v_retval := '<table><tr><th>ISR_OAM_RISIKOAKZEPTANZKRITERIEN</th><th>Column</th></tr>'
                        || '<tr><td>rak_uid</td><td>'
                        || to_char(pir_row.rak_uid)
                        || '</td></tr>'
                        || '<tr><td>rak_bezeichnung</td><td>'
                        || pir_row.rak_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>rak_wert</td><td>'
                        || to_char(pir_row.rak_wert)
                        || '</td></tr>'
                        || '<tr><td>rak_beschreibung</td><td>'
                        || pir_row.rak_beschreibung
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
        pior_isr_oam_risikoakzeptanzkriterien in out isr_oam_risikoakzeptanzkriterien%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_risikoakzeptanzkriterien.inserted := sysdate;
        pior_isr_oam_risikoakzeptanzkriterien.inserted_by := pck_env.fv_user;
        insert into isr_oam_risikoakzeptanzkriterien values pior_isr_oam_risikoakzeptanzkriterien returning rak_uid into pior_isr_oam_risikoakzeptanzkriterien.rak_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_risikoakzeptanzkriterien! Parameter: ' || fv_print(pir_row => pior_isr_oam_risikoakzeptanzkriterien
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_risikoakzeptanzkriterien in isr_oam_risikoakzeptanzkriterien%rowtype
    ) is
        r_isr_oam_risikoakzeptanzkriterien isr_oam_risikoakzeptanzkriterien%rowtype;

  -- fuer exceptions
        v_routine_name                     logs.routine_name%type;
        c_message                          clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_risikoakzeptanzkriterien := pir_isr_oam_risikoakzeptanzkriterien;
        r_isr_oam_risikoakzeptanzkriterien.inserted := sysdate;
        r_isr_oam_risikoakzeptanzkriterien.updated := sysdate;
        r_isr_oam_risikoakzeptanzkriterien.inserted_by := pck_env.fv_user;
        r_isr_oam_risikoakzeptanzkriterien.updated_by := pck_env.fv_user;
        merge into isr_oam_risikoakzeptanzkriterien
        using dual on ( rak_uid = r_isr_oam_risikoakzeptanzkriterien.rak_uid )
        when matched then update
        set rak_bezeichnung = r_isr_oam_risikoakzeptanzkriterien.rak_bezeichnung,
            rak_wert = r_isr_oam_risikoakzeptanzkriterien.rak_wert,
            rak_beschreibung = r_isr_oam_risikoakzeptanzkriterien.rak_beschreibung,
            updated = r_isr_oam_risikoakzeptanzkriterien.updated,
            updated_by = r_isr_oam_risikoakzeptanzkriterien.updated_by
        when not matched then
        insert (
            rak_bezeichnung,
            rak_wert,
            rak_beschreibung,
            inserted,
            inserted_by )
        values
            ( r_isr_oam_risikoakzeptanzkriterien.rak_bezeichnung,
              r_isr_oam_risikoakzeptanzkriterien.rak_wert,
              r_isr_oam_risikoakzeptanzkriterien.rak_beschreibung,
              r_isr_oam_risikoakzeptanzkriterien.inserted,
              r_isr_oam_risikoakzeptanzkriterien.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_risikoakzeptanzkriterien);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_isr_oam_risikoakzeptanzkriterien in isr_oam_risikoakzeptanzkriterien%rowtype,
        piv_art                              in varchar2
    ) is
        r_isr_oam_risikoakzeptanzkriterien isr_oam_risikoakzeptanzkriterien%rowtype;        

-- fuer exceptions        
        v_routine_name                     logs.routine_name%type;
        c_message                          clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_oam_risikoakzeptanzkriterien := pir_isr_oam_risikoakzeptanzkriterien;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_risikoakzeptanzkriterien.inserted,
                    r_isr_oam_risikoakzeptanzkriterien.inserted_by
                from
                    isr_oam_risikoakzeptanzkriterien
                where
                    rak_uid = pir_isr_oam_risikoakzeptanzkriterien.rak_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_oam_risikoakzeptanzkriterien.updated := sysdate;
                r_isr_oam_risikoakzeptanzkriterien.updated_by := pck_env.fv_user;
                update isr_oam_risikoakzeptanzkriterien
                set
                    row = r_isr_oam_risikoakzeptanzkriterien
                where
                    rak_uid = pir_isr_oam_risikoakzeptanzkriterien.rak_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_risikoakzeptanzkriterien);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_rak_uid in isr_oam_risikoakzeptanzkriterien.rak_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_rak_uid: ' || to_char(pin_rak_uid);
        delete from isr_oam_risikoakzeptanzkriterien
        where
            rak_uid = pin_rak_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_risikoakzeptanzkriterien! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_risikoakzeptanzkriterien! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_oam_risikoakzeptanzkriterien_dml;
/

