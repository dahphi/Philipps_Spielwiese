-- liquibase formatted sql
-- changeset AM_MAIN:1774557116909 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_funk_infcluster_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_funk_infcluster_dml.sql:null:9f2a0facecc184a2c8a31b2d295e9b2ca2b374e6:create

create or replace package body am_main.pck_hwas_funk_infcluster_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in hwas_funk_infcluster%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'FKIN_UID = '
                        || to_char(pir_row.fkin_uid)
                        || cv_sep
                        || ', FKL_UID = '
                        || pir_row.fkl_uid
                        || cv_sep
                        || ', INCL_UID = '
                        || pir_row.incl_uid
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
            v_retval := '<table><tr><th>RK_MAIN.HWAS_FUNK_INFCLUSTER</th><th>Column</th></tr>'
                        || '<tr><td>FKIN_UID</td><td>'
                        || to_char(pir_row.fkin_uid)
                        || '</td></tr>'
                        || '<tr><td>FKL_UID</td><td>'
                        || pir_row.fkl_uid
                        || '</td></tr>'
                        || '<tr><td>INCL_UID</td><td>'
                        || pir_row.incl_uid
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
        pior_hwas_funk_infcluster in out hwas_funk_infcluster%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwas_funk_infcluster.inserted := sysdate;
        pior_hwas_funk_infcluster.inserted_by := pck_env.fv_user;
        insert into hwas_funk_infcluster values pior_hwas_funk_infcluster returning fkin_uid into pior_hwas_funk_infcluster.fkin_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle HWAS_FUNK_INFCLUSTER! Parameter: ' || fv_print(pir_row => pior_hwas_funk_infcluster
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

------------------------------------------------------------------------------------------

    procedure p_insert (
        pi_fkl_uid  in hwas_funk_infcluster.fkl_uid%type,
        pi_incl_uid in hwas_funk_infcluster.incl_uid%type
    ) is
        v_conter   number := 0;
        v_sequence number;
    begin
        select
            count(*)
        into v_conter
        from
            hwas_funk_infcluster
        where
                fkl_uid = pi_fkl_uid
            and incl_uid = pi_incl_uid;

        if v_conter = 0 then
            insert into hwas_funk_infcluster (
        --RE_ID,
                fkl_uid,
                incl_uid,
                inserted,
                inserted_by
            ) values (
          --v_sequence,
             pi_fkl_uid,
                       pi_incl_uid,
                       sysdate,
                       v('APP_USER') );

        end if;

    end p_insert;
-------------------------------------------------------------------------------

    procedure p_merge (
        pir_hwas_funk_infcluster in hwas_funk_infcluster%rowtype
    ) is
        r_hwas_funk_infcluster hwas_funk_infcluster%rowtype;

  -- fuer exceptions
        v_routine_name         logs.routine_name%type;
        c_message              clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_hwas_funk_infcluster := pir_hwas_funk_infcluster;
        r_hwas_funk_infcluster.inserted := sysdate;
        r_hwas_funk_infcluster.updated := sysdate;
        r_hwas_funk_infcluster.inserted_by := pck_env.fv_user;
        r_hwas_funk_infcluster.updated_by := pck_env.fv_user;
        merge into hwas_funk_infcluster
        using dual on ( fkin_uid = r_hwas_funk_infcluster.fkin_uid )
        when matched then update
        set fkl_uid = r_hwas_funk_infcluster.fkl_uid,
            incl_uid = r_hwas_funk_infcluster.incl_uid,
            updated = r_hwas_funk_infcluster.updated,
            updated_by = r_hwas_funk_infcluster.updated_by
        when not matched then
        insert (
            fkl_uid,
            incl_uid,
            inserted,
            inserted_by )
        values
            ( r_hwas_funk_infcluster.fkl_uid,
              r_hwas_funk_infcluster.incl_uid,
              r_hwas_funk_infcluster.inserted,
              r_hwas_funk_infcluster.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_hwas_funk_infcluster);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_hwas_funk_infcluster in hwas_funk_infcluster%rowtype,
        piv_art                  in varchar2
    ) is
        r_hwas_funk_infcluster hwas_funk_infcluster%rowtype;        

-- fuer exceptions        
        v_routine_name         logs.routine_name%type;
        c_message              clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_hwas_funk_infcluster := pir_hwas_funk_infcluster;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_hwas_funk_infcluster.inserted,
                    r_hwas_funk_infcluster.inserted_by
                from
                    hwas_funk_infcluster
                where
                    fkl_uid = pir_hwas_funk_infcluster.fkl_uid;  
      -- Ergänzen der Update-Daten  
                r_hwas_funk_infcluster.updated := sysdate;
                r_hwas_funk_infcluster.updated_by := pck_env.fv_user;
                update hwas_funk_infcluster
                set
                    row = r_hwas_funk_infcluster
                where
                    fkl_uid = pir_hwas_funk_infcluster.fkl_uid;

            when '<only_aktiv>' then
                update hwas_funk_infcluster
                set
                    updated = sysdate,
                    updated_by = pck_env.fv_user
                where
                    fkl_uid = pir_hwas_funk_infcluster.fkl_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_hwas_funk_infcluster);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_fkl_uid in hwas_funk_infcluster.fkl_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_FKL_UID: ' || to_char(pin_fkl_uid);
        delete from hwas_funk_infcluster
        where
            fkl_uid = pin_fkl_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle HWAS_FUNK_INFCLUSTER! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle HWAS_FUNK_INFCLUSTER! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_hwas_funk_infcluster_dml;
/

