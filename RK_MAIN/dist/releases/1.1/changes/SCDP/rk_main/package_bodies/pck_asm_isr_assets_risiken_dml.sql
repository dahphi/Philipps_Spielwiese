-- liquibase formatted sql
-- changeset RK_MAIN:1774555709889 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_asm_isr_assets_risiken_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_asm_isr_assets_risiken_dml.sql:null:3016c1c0c69a72abb331072de83278256fde31a1:create

create or replace package body rk_main.pck_asm_isr_assets_risiken_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_rsk         in rsk_asm_isr_assets_risiken,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'asri_uid = '
                        || to_char(pir_rsk.asri_uid)
                        || cv_sep
                        || ', rsk_uid = '
                        || to_char(pir_rsk.rsk_uid)
                        || cv_sep
                        || ', assets = '
                        || to_char(pir_rsk.assets)
                        || cv_sep
                        || ', inserted = '
                        || to_char(pir_rsk.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', updated = '
                        || to_char(pir_rsk.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', inserted_by = '
                        || pir_rsk.inserted_by
                        || cv_sep
                        || ', updated_by = '
                        || pir_rsk.updated_by
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
            v_retval := '<table><tr><th>asm_isr_assets_risiken</th><th>Column</th></tr>'
                        || '<tr><td>asri_uid</td><td>'
                        || to_char(pir_rsk.asri_uid)
                        || '</td></tr>'
                        || '<tr><td>rsk_uid</td><td>'
                        || to_char(pir_rsk.rsk_uid)
                        || '</td></tr>'
                        || '<tr><td>assets</td><td>'
                        || to_char(pir_rsk.assets)
                        || '</td></tr>'
                        || '<tr><td>inserted</td><td>'
                        || to_char(pir_rsk.inserted, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>updated</td><td>'
                        || to_char(pir_rsk.updated, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>inserted_by</td><td>'
                        || pir_rsk.inserted_by
                        || '</td></tr>'
                        || '<tr><td>updated_by</td><td>'
                        || pir_rsk.updated_by
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_ass         in ass_asm_isr_assets_risiken,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'asri_uid = '
                        || to_char(pir_ass.asri_uid)
                        || cv_sep
                        || ', ass_uid = '
                        || to_char(pir_ass.ass_uid)
                        || cv_sep
                        || ', risiken = '
                        || to_char(pir_ass.risiken)
                        || cv_sep
                        || ', inserted = '
                        || to_char(pir_ass.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', updated = '
                        || to_char(pir_ass.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', inserted_by = '
                        || pir_ass.inserted_by
                        || cv_sep
                        || ', updated_by = '
                        || pir_ass.updated_by
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
            v_retval := '<table><tr><th>asm_isr_assets_risiken</th><th>Column</th></tr>'
                        || '<tr><td>asri_uid</td><td>'
                        || to_char(pir_ass.asri_uid)
                        || '</td></tr>'
                        || '<tr><td>ass_uid</td><td>'
                        || to_char(pir_ass.ass_uid)
                        || '</td></tr>'
                        || '<tr><td>risiken</td><td>'
                        || to_char(pir_ass.risiken)
                        || '</td></tr>'
                        || '<tr><td>inserted</td><td>'
                        || to_char(pir_ass.inserted, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>updated</td><td>'
                        || to_char(pir_ass.updated, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>inserted_by</td><td>'
                        || pir_ass.inserted_by
                        || '</td></tr>'
                        || '<tr><td>updated_by</td><td>'
                        || pir_ass.updated_by
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------
    procedure p_insert (
        pir_rsk_asm_isr_assets_risiken in rsk_asm_isr_assets_risiken
    ) is

  -- fuer exceptions
        v_routine_name                logs.routine_name%type;
        c_message                     clob;
        r_asm_isr_assets_risiken      asm_isr_assets_risiken%rowtype;
        r_asm_isr_assets_risiken_hist asm_isr_assets_risiken_hist%rowtype;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_asm_isr_assets_risiken.rsk_uid := pir_rsk_asm_isr_assets_risiken.rsk_uid;
        r_asm_isr_assets_risiken.inserted := sysdate;
        r_asm_isr_assets_risiken.inserted_by := pck_env.fv_user;
        for rsk in (
        /* Zerlegen des ':'-getennten Strings in einzelne UIDs */
            select
                trim(regexp_substr(pir_rsk_asm_isr_assets_risiken.assets, '[^:]+', 1, level)) ass_uid
            from
                dual
            connect by
                instr(pir_rsk_asm_isr_assets_risiken.assets, ':', 1, level - 1) > 0
        ) loop
            if rsk.ass_uid is not null then
                r_asm_isr_assets_risiken.asri_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                r_asm_isr_assets_risiken.ass_uid := rsk.ass_uid;
                insert into asm_isr_assets_risiken values r_asm_isr_assets_risiken;
            --History--
                r_asm_isr_assets_risiken_hist.asri_uid := r_asm_isr_assets_risiken.asri_uid;
                r_asm_isr_assets_risiken_hist.insert_info := 'Asset wurde hinzugefügt';
                pck_asm_isr_assets_risiken_hist_dml.p_insert(pior_assets_risiken_hist => r_asm_isr_assets_risiken_hist);
            end if;
        end loop;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle asm_isr_assets_risiken! Parameter: ' || fv_print(pir_rsk_asm_isr_assets_risiken
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------
    procedure p_insert (
        pir_ass_asm_isr_assets_risiken in ass_asm_isr_assets_risiken
    ) is

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
        r_asm_isr_assets_risiken asm_isr_assets_risiken%rowtype;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_asm_isr_assets_risiken.ass_uid := pir_ass_asm_isr_assets_risiken.ass_uid;
        r_asm_isr_assets_risiken.inserted := sysdate;
        r_asm_isr_assets_risiken.inserted_by := pck_env.fv_user;

   -- for ass in (
        /* Zerlegen des ':'-getennten Strings in einzelne UIDs */
    --    SELECT trim(regexp_substr(pir_ass_asm_isr_assets_risiken.risiken, '[^:]+', 1, LEVEL)) rsk_uid
    --    FROM dual
    --    CONNECT BY instr(pir_ass_asm_isr_assets_risiken.risiken, ':', 1, LEVEL - 1) > 0  
   -- )
        for ass in (
        /* Zerlegen des ':'-getrennten Strings in einzelne UIDs und nur nicht-leere Einträge berücksichtigen */
            select
                trim(regexp_substr(pir_ass_asm_isr_assets_risiken.risiken, '[^:]+', 1, level)) rsk_uid
            from
                dual
            connect by instr(pir_ass_asm_isr_assets_risiken.risiken, ':', 1, level - 1) > 0
                       and trim(regexp_substr(pir_ass_asm_isr_assets_risiken.risiken, '[^:]+', 1, level)) is not null
        ) loop
            if ass.rsk_uid is not null then
                r_asm_isr_assets_risiken.asri_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                r_asm_isr_assets_risiken.rsk_uid := ass.rsk_uid;
                insert into asm_isr_assets_risiken values r_asm_isr_assets_risiken;

            end if;
        end loop;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle asm_isr_assets_risiken! Parameter: ' || fv_print(pir_ass_asm_isr_assets_risiken
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_rsk_asm_isr_assets_risiken in rsk_asm_isr_assets_risiken,
        piv_art                        in varchar2
    ) is

        r_rsk_asm_isr_assets_risiken  rsk_asm_isr_assets_risiken;
        r_asm_isr_assets_risiken      asm_isr_assets_risiken%rowtype;
        r_asm_isr_assets_risiken_hist asm_isr_assets_risiken_hist%rowtype;
        v_asri_uid                    number;

-- fuer exceptions        
        v_routine_name                logs.routine_name%type;
        c_message                     clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Löschen der gelösten Verknüpfungen
                begin
                    for del_row in (
                        select
                            asri_uid
                        from
                            asm_isr_assets_risiken
                        where
                                rsk_uid = pir_rsk_asm_isr_assets_risiken.rsk_uid
                            and instr(':'
                                      || pir_rsk_asm_isr_assets_risiken.assets
                                      || ':', ':'
                                              || ass_uid
                                              || ':') = 0
                    ) loop
  -- History
                        r_asm_isr_assets_risiken_hist.asri_uid := del_row.asri_uid;
                        r_asm_isr_assets_risiken_hist.insert_info := 'Asset wurde entfernt';
                        pck_asm_isr_assets_risiken_hist_dml.p_insert(pior_assets_risiken_hist => r_asm_isr_assets_risiken_hist);

  -- Delete
                        delete from asm_isr_assets_risiken
                        where
                            asri_uid = del_row.asri_uid;

                    end loop;
                exception
                    when no_data_found then
                        null;
                end;

      -- Übernehmen der Eingabedaten  
                r_asm_isr_assets_risiken.rsk_uid := pir_rsk_asm_isr_assets_risiken.rsk_uid;
      -- Ergänzen der Anlagedaten aus dem verknüpften Risiko
                r_asm_isr_assets_risiken.inserted := sysdate;
                r_asm_isr_assets_risiken.inserted_by := pck_env.fv_user; 

      -- Einfügen der hinzugefügten Verknüpfungen
                for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
                    select
                        trim(regexp_substr(pir_rsk_asm_isr_assets_risiken.assets, '[^:]+', 1, level)) ass_uid
                    from
                        dual
                    connect by
                        instr(pir_rsk_asm_isr_assets_risiken.assets, ':', 1, level - 1) > 0
                    minus
            -- Ausscließen der bereits gespeicherten Verknüpfungen
                    select
                        to_char(ass_uid)
                    from
                        asm_isr_assets_risiken
                    where
                        rsk_uid = pir_rsk_asm_isr_assets_risiken.rsk_uid
                ) loop
                    if rsk.ass_uid is not null then
                        r_asm_isr_assets_risiken.asri_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                        r_asm_isr_assets_risiken.ass_uid := rsk.ass_uid;
                        insert into asm_isr_assets_risiken values r_asm_isr_assets_risiken;
            --History--
                        r_asm_isr_assets_risiken_hist.asri_uid := r_asm_isr_assets_risiken.asri_uid;
                        r_asm_isr_assets_risiken_hist.insert_info := 'Asset wurde hinzugefüht';
                        pck_asm_isr_assets_risiken_hist_dml.p_insert(pior_assets_risiken_hist => r_asm_isr_assets_risiken_hist);
                    end if;
                end loop;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_rsk_asm_isr_assets_risiken);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        

--Mit Friedfhof
    procedure p_update (
        pir_rsk_asm_isr_assets_risiken in rsk_asm_isr_assets_risiken,
        piv_art                        in varchar2,
        piv_friedhof                   in number
    ) is

        r_rsk_asm_isr_assets_risiken  rsk_asm_isr_assets_risiken;
        r_asm_isr_assets_risiken      asm_isr_assets_risiken%rowtype;
        r_asm_isr_assets_risiken_hist asm_isr_assets_risiken_hist%rowtype;
        v_asri_uid                    number;

-- fuer exceptions        
        v_routine_name                logs.routine_name%type;
        c_message                     clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Löschen der gelösten Verknüpfungen
                begin
                    for del_row in (
                        select
                            air.asri_uid
                        from
                                 asm_isr_assets_risiken air
                            join rk_apex.v_risikorelevante_assets_new van on van.asset_uid = air.ass_uid
                            left join awh_main.awh_tab_infosec_sys_status  atiss on atiss.sta_lfd_nr = van.status
                        where
                                air.rsk_uid = pir_rsk_asm_isr_assets_risiken.rsk_uid
                            and ( ( piv_friedhof = 1
                                    and ( atiss.sta_sichtbarkeit = 1
                                          or atiss.sta_sichtbarkeit is null ) )
                                  or ( piv_friedhof = 0
                                       and atiss.sta_sichtbarkeit = 0 ) )
                            and instr(':'
                                      || pir_rsk_asm_isr_assets_risiken.assets
                                      || ':', ':'
                                              || air.ass_uid
                                              || ':') = 0
      
          --FOR del_row IN (
  --SELECT asri_uid
  --FROM asm_isr_assets_risiken
  --WHERE rsk_uid = pir_rsk_asm_isr_assets_risiken.rsk_uid
  --AND instr(':' || pir_rsk_asm_isr_assets_risiken.assets || ':', ':' || ass_uid || ':') = 0
                    ) loop
  -- History
                        r_asm_isr_assets_risiken_hist.asri_uid := del_row.asri_uid;
                        r_asm_isr_assets_risiken_hist.insert_info := 'Asset wurde entfernt';
                        pck_asm_isr_assets_risiken_hist_dml.p_insert(pior_assets_risiken_hist => r_asm_isr_assets_risiken_hist);

  -- Delete
                        delete from asm_isr_assets_risiken
                        where
                            asri_uid = del_row.asri_uid;

                    end loop;
                exception
                    when no_data_found then
                        null;
                end;

      -- Übernehmen der Eingabedaten  
                r_asm_isr_assets_risiken.rsk_uid := pir_rsk_asm_isr_assets_risiken.rsk_uid;
      -- Ergänzen der Anlagedaten aus dem verknüpften Risiko
                r_asm_isr_assets_risiken.inserted := sysdate;
                r_asm_isr_assets_risiken.inserted_by := pck_env.fv_user; 

      -- Einfügen der hinzugefügten Verknüpfungen
                for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
                    select
                        trim(regexp_substr(pir_rsk_asm_isr_assets_risiken.assets, '[^:]+', 1, level)) ass_uid
                    from
                        dual
                    connect by
                        instr(pir_rsk_asm_isr_assets_risiken.assets, ':', 1, level - 1) > 0
                    minus
            -- Ausscließen der bereits gespeicherten Verknüpfungen
                    select
                        to_char(ass_uid)
                    from
                        asm_isr_assets_risiken
                    where
                        rsk_uid = pir_rsk_asm_isr_assets_risiken.rsk_uid
                ) loop
                    if rsk.ass_uid is not null then
                        r_asm_isr_assets_risiken.asri_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                        r_asm_isr_assets_risiken.ass_uid := rsk.ass_uid;
                        insert into asm_isr_assets_risiken values r_asm_isr_assets_risiken;
            --History--
                        r_asm_isr_assets_risiken_hist.asri_uid := r_asm_isr_assets_risiken.asri_uid;
                        r_asm_isr_assets_risiken_hist.insert_info := 'Asset wurde hinzugefüht';
                        pck_asm_isr_assets_risiken_hist_dml.p_insert(pior_assets_risiken_hist => r_asm_isr_assets_risiken_hist);
                    end if;
                end loop;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_rsk_asm_isr_assets_risiken);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        
---------------------------------------------------------------------------------------------------
/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_ass_asm_isr_assets_risiken in ass_asm_isr_assets_risiken,
        piv_art                        in varchar2
    ) is
        r_ass_asm_isr_assets_risiken ass_asm_isr_assets_risiken;
        r_asm_isr_assets_risiken     asm_isr_assets_risiken%rowtype;

-- fuer exceptions        
        v_routine_name               logs.routine_name%type;
        c_message                    clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Löschen der gelösten Verknüpfungen
                begin
                    delete from asm_isr_assets_risiken
                    where
                            ass_uid = pir_ass_asm_isr_assets_risiken.ass_uid
                        and instr(':'
                                  || pir_ass_asm_isr_assets_risiken.risiken
                                  || ':', ':'
                                          || rsk_uid
                                          || ':') = 0; -- uid nicht im String vorhande
                exception
                    when no_data_found then
                        null;
                end;

      -- Übernehmen der Eingabedaten  
                r_asm_isr_assets_risiken.ass_uid := pir_ass_asm_isr_assets_risiken.ass_uid;
                r_asm_isr_assets_risiken.inserted := sysdate;
                r_asm_isr_assets_risiken.inserted_by := pck_env.fv_user; 

      -- Einfügen der hinzugefügten Verknüpfungen
                for ass in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
                    select
                        trim(regexp_substr(pir_ass_asm_isr_assets_risiken.risiken, '[^:]+', 1, level)) rsk_uid
                    from
                        dual
                    connect by
                        instr(pir_ass_asm_isr_assets_risiken.risiken, ':', 1, level - 1) > 0
                    minus
            -- Ausscließen der bereits gespeicherten Verknüpfungen
                    select
                        to_char(rsk_uid)
                    from
                        asm_isr_assets_risiken
                    where
                        ass_uid = pir_ass_asm_isr_assets_risiken.ass_uid
                ) loop
                    if ass.rsk_uid is not null then
                        r_asm_isr_assets_risiken.asri_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                        r_asm_isr_assets_risiken.rsk_uid := ass.rsk_uid;
                        insert into asm_isr_assets_risiken values r_asm_isr_assets_risiken;

                    end if;
                end loop;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_ass_asm_isr_assets_risiken);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;             
---------------------------------------------------------------------------------------------------

    procedure p_delete_for_rsk (
        pin_rsk_uid in asm_isr_assets_risiken.rsk_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_rsk_uid: ' || to_char(pin_rsk_uid);
        delete from asm_isr_assets_risiken
        where
            rsk_uid = pin_rsk_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle asm_isr_assets_risiken! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle asm_isr_assets_risiken! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_rsk;

    procedure p_delete_for_ass (
        pin_ass_uid in asm_isr_assets_risiken.ass_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ass_uid: ' || to_char(pin_ass_uid);
        delete from asm_isr_assets_risiken
        where
            ass_uid = pin_ass_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle asm_isr_assets_risiken! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle asm_isr_assets_risiken! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_ass;

    procedure p_delete_for_rsk_ass (
        pin_ass_uid in asm_isr_assets_risiken.ass_uid%type,
        pin_rsk_uid in asm_isr_assets_risiken.rsk_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ass_uid: ' || to_char(pin_ass_uid);
        delete from asm_isr_assets_risiken
        where
                ass_uid = pin_ass_uid
            and rsk_uid = pin_rsk_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle asm_isr_assets_risiken! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle asm_isr_assets_risiken! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_rsk_ass;

end pck_asm_isr_assets_risiken_dml;
/

