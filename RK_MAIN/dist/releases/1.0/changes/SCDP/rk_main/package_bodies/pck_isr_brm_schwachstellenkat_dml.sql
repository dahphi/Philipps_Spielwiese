-- liquibase formatted sql
-- changeset RK_MAIN:1774554918103 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_brm_schwachstellenkat_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_brm_schwachstellenkat_dml.sql:null:d0863bc88490f70bbb1e527670b40ac65aedf670:create

create or replace package body rk_main.pck_isr_brm_schwachstellenkat_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_brm_schwachstellenkat%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ska_uid = '
                        || to_char(pir_row.ska_uid)
                        || cv_sep
                        || ', ska_titel = '
                        || pir_row.ska_titel
                        || cv_sep
                        || ', ska_beschreibung = '
                        || pir_row.ska_beschreibung
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
            v_retval := '<table><tr><th>ISR_BRM_SCHWACHSTELLENKAT</th><th>Column</th></tr>'
                        || '<tr><td>ska_uid</td><td>'
                        || to_char(pir_row.ska_uid)
                        || '</td></tr>'
                        || '<tr><td>ska_titel</td><td>'
                        || pir_row.ska_titel
                        || '</td></tr>'
                        || '<tr><td>ska_beschreibung</td><td>'
                        || pir_row.ska_beschreibung
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
        pior_isr_brm_schwachstellenkat in out isr_brm_schwachstellenkat%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_brm_schwachstellenkat.inserted := sysdate;
        pior_isr_brm_schwachstellenkat.inserted_by := pck_env.fv_user;
        insert into isr_brm_schwachstellenkat values pior_isr_brm_schwachstellenkat returning ska_uid into pior_isr_brm_schwachstellenkat.ska_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_brm_schwachstellenkat! Parameter: ' || fv_print(pir_row => pior_isr_brm_schwachstellenkat
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_brm_schwachstellenkat in isr_brm_schwachstellenkat%rowtype
    ) is
        r_isr_brm_schwachstellenkat isr_brm_schwachstellenkat%rowtype;

  -- fuer exceptions
        v_routine_name              logs.routine_name%type;
        c_message                   clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_brm_schwachstellenkat := pir_isr_brm_schwachstellenkat;
        r_isr_brm_schwachstellenkat.inserted := sysdate;
        r_isr_brm_schwachstellenkat.updated := sysdate;
        r_isr_brm_schwachstellenkat.inserted_by := pck_env.fv_user;
        r_isr_brm_schwachstellenkat.updated_by := pck_env.fv_user;
        merge into isr_brm_schwachstellenkat
        using dual on ( ska_uid = r_isr_brm_schwachstellenkat.ska_uid )
        when matched then update
        set ska_titel = r_isr_brm_schwachstellenkat.ska_titel,
            ska_beschreibung = r_isr_brm_schwachstellenkat.ska_beschreibung,
            updated = r_isr_brm_schwachstellenkat.updated,
            updated_by = r_isr_brm_schwachstellenkat.updated_by
        when not matched then
        insert (
            ska_titel,
            ska_beschreibung,
            inserted,
            inserted_by )
        values
            ( r_isr_brm_schwachstellenkat.ska_titel,
              r_isr_brm_schwachstellenkat.ska_beschreibung,
              r_isr_brm_schwachstellenkat.inserted,
              r_isr_brm_schwachstellenkat.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_brm_schwachstellenkat);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------
/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_isr_brm_schwachstellenkat in isr_brm_schwachstellenkat%rowtype,
        piv_art                       in varchar2
    ) is
        r_isr_brm_schwachstellenkat isr_brm_schwachstellenkat%rowtype;        

-- fuer exceptions        
        v_routine_name              logs.routine_name%type;
        c_message                   clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_brm_schwachstellenkat := pir_isr_brm_schwachstellenkat;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_brm_schwachstellenkat.inserted,
                    r_isr_brm_schwachstellenkat.inserted_by
                from
                    isr_brm_schwachstellenkat
                where
                    ska_uid = pir_isr_brm_schwachstellenkat.ska_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_brm_schwachstellenkat.updated := sysdate;
                r_isr_brm_schwachstellenkat.updated_by := pck_env.fv_user;
                update isr_brm_schwachstellenkat
                set
                    row = r_isr_brm_schwachstellenkat
                where
                    ska_uid = pir_isr_brm_schwachstellenkat.ska_uid;

            when '<only_aktiv>' then
                update isr_brm_schwachstellenkat
                set
                    updated = sysdate,
                    updated_by = pck_env.fv_user,
                    aktiv = pir_isr_brm_schwachstellenkat.aktiv
                where
                    ska_uid = pir_isr_brm_schwachstellenkat.ska_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_brm_schwachstellenkat);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ska_uid in isr_brm_schwachstellenkat.ska_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ska_uid: ' || to_char(pin_ska_uid);
        delete from isr_brm_schwachstellenkat
        where
            ska_uid = pin_ska_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_brm_schwachstellenkat! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_brm_schwachstellenkat! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_brm_schwachstellenkat_dml;
/

