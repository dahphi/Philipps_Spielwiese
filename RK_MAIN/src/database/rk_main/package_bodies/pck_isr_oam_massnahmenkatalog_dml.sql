create or replace package body rk_main.pck_isr_oam_massnahmenkatalog_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_rsk         in rsk_isr_oam_massnahmenkatalog,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'mnk_uid = '
                        || to_char(pir_rsk.mnk_uid)
                        || cv_sep
                        || ', rsk_uid = '
                        || to_char(pir_rsk.rsk_uid)
                        || cv_sep
                        || ', massnahmen = '
                        || to_char(pir_rsk.massnahmen)
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
            v_retval := '<table><tr><th>RK_MAIN.ISR_OAM_massnahmenkatalog</th><th>Column</th></tr>'
                        || '<tr><td>mnk_uid</td><td>'
                        || to_char(pir_rsk.mnk_uid)
                        || '</td></tr>'
                        || '<tr><td>rsk_uid</td><td>'
                        || to_char(pir_rsk.rsk_uid)
                        || '</td></tr>'
                        || '<tr><td>massnahmen</td><td>'
                        || to_char(pir_rsk.massnahmen)
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
        pir_msn         in msn_isr_oam_massnahmenkatalog,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'mnk_uid = '
                        || to_char(pir_msn.mnk_uid)
                        || cv_sep
                        || ', msn_uid = '
                        || to_char(pir_msn.msn_uid)
                        || cv_sep
                        || ', risiken = '
                        || to_char(pir_msn.risiken)
                        || cv_sep
                        || ', inserted = '
                        || to_char(pir_msn.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', updated = '
                        || to_char(pir_msn.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', inserted_by = '
                        || pir_msn.inserted_by
                        || cv_sep
                        || ', updated_by = '
                        || pir_msn.updated_by
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
            v_retval := '<table><tr><th>RK_MAIN.ISR_OAM_massnahmenkatalog</th><th>Column</th></tr>'
                        || '<tr><td>mnk_uid</td><td>'
                        || to_char(pir_msn.mnk_uid)
                        || '</td></tr>'
                        || '<tr><td>msn_uid</td><td>'
                        || to_char(pir_msn.msn_uid)
                        || '</td></tr>'
                        || '<tr><td>risiken</td><td>'
                        || to_char(pir_msn.risiken)
                        || '</td></tr>'
                        || '<tr><td>inserted</td><td>'
                        || to_char(pir_msn.inserted, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>updated</td><td>'
                        || to_char(pir_msn.updated, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>inserted_by</td><td>'
                        || pir_msn.inserted_by
                        || '</td></tr>'
                        || '<tr><td>updated_by</td><td>'
                        || pir_msn.updated_by
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------
    procedure p_insert (
        pir_rsk_isr_oam_massnahmenkatalog in rsk_isr_oam_massnahmenkatalog
    ) is

  -- fuer exceptions
        v_routine_name              logs.routine_name%type;
        c_message                   clob;
        r_isr_oam_massnahmenkatalog isr_oam_massnahmenkatalog%rowtype;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_isr_oam_massnahmenkatalog.rsk_uid := pir_rsk_isr_oam_massnahmenkatalog.rsk_uid;
        r_isr_oam_massnahmenkatalog.inserted := sysdate;
        r_isr_oam_massnahmenkatalog.inserted_by := pck_env.fv_user;
        for rsk in (
        /* Zerlegen des ':'-getennten Strings in einzelne UIDs */
            select
                trim(regexp_substr(pir_rsk_isr_oam_massnahmenkatalog.massnahmen, '[^:]+', 1, level)) msn_uid
            from
                dual
            connect by
                instr(pir_rsk_isr_oam_massnahmenkatalog.massnahmen, ':', 1, level - 1) > 0
        ) loop
            if rsk.msn_uid is not null then
                r_isr_oam_massnahmenkatalog.mnk_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                r_isr_oam_massnahmenkatalog.msn_uid := rsk.msn_uid;
                insert into isr_oam_massnahmenkatalog values r_isr_oam_massnahmenkatalog;

            end if;
        end loop;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_massnahmenkatalog! Parameter: ' || fv_print(pir_rsk_isr_oam_massnahmenkatalog
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------
    procedure p_insert (
        pir_msn_isr_oam_massnahmenkatalog in msn_isr_oam_massnahmenkatalog
    ) is

  -- fuer exceptions
        v_routine_name                   logs.routine_name%type;
        c_message                        clob;
        r_isr_oam_massnahmenkatalog      isr_oam_massnahmenkatalog%rowtype;
        r_isr_oam_massnahmenkatalog_hist isr_oam_massnahmenkatalog_hist%rowtype;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_isr_oam_massnahmenkatalog.msn_uid := pir_msn_isr_oam_massnahmenkatalog.msn_uid;
        r_isr_oam_massnahmenkatalog.inserted := sysdate;
        r_isr_oam_massnahmenkatalog.inserted_by := pck_env.fv_user;
        for msn in (
        /* Zerlegen des ':'-getennten Strings in einzelne UIDs */
            select
                trim(regexp_substr(pir_msn_isr_oam_massnahmenkatalog.risiken, '[^:]+', 1, level)) rsk_uid
            from
                dual
            connect by
                instr(pir_msn_isr_oam_massnahmenkatalog.risiken, ':', 1, level - 1) > 0
        ) loop
            if msn.rsk_uid is not null then
                r_isr_oam_massnahmenkatalog.mnk_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                r_isr_oam_massnahmenkatalog.rsk_uid := msn.rsk_uid;
                insert into isr_oam_massnahmenkatalog values r_isr_oam_massnahmenkatalog;

           --History--
                r_isr_oam_massnahmenkatalog_hist.mnk_uid := r_isr_oam_massnahmenkatalog.mnk_uid;
                r_isr_oam_massnahmenkatalog_hist.insert_info := 'Maßnahme  wurden hinzugefüht';
                rk_main.pck_isr_oam_massnahmenkatalog_hist_dml.p_insert(pior_massnahmenkatalog_hist => r_isr_oam_massnahmenkatalog_hist
                );
            end if;
        end loop;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_massnahmenkatalog! Parameter: ' || fv_print(pir_msn_isr_oam_massnahmenkatalog
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;
-------------------------------------------------------------------------------

    procedure p_insert_in_katalog (
        p_rsk_uid in number,
        p_msn_uid in number
    ) is
    begin
        insert into rk_main.isr_oam_massnahmenkatalog (
            mnk_uid,
            rsk_uid,
            msn_uid,
            inserted,
            updated,
            inserted_by,
            updated_by
        ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                   p_rsk_uid,
                   p_msn_uid,
                   sysdate,
                   null,
                   v('APP_USER'),
                   null );

    end p_insert_in_katalog;


/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_rsk_isr_oam_massnahmenkatalog in rsk_isr_oam_massnahmenkatalog,
        piv_art                           in varchar2
    ) is

        r_rsk_isr_oam_massnahmenkatalog  rsk_isr_oam_massnahmenkatalog;
        r_isr_oam_massnahmenkatalog      isr_oam_massnahmenkatalog%rowtype;
        r_isr_oam_massnahmenkatalog_hist isr_oam_massnahmenkatalog_hist%rowtype;

-- fuer exceptions        
        v_routine_name                   logs.routine_name%type;
        c_message                        clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Löschen der gelösten Verknüpfungen
                delete from isr_oam_massnahmenkatalog
                where
                        rsk_uid = pir_rsk_isr_oam_massnahmenkatalog.rsk_uid
                    and instr(':'
                              || pir_rsk_isr_oam_massnahmenkatalog.massnahmen
                              || ':', ':'
                                      || msn_uid
                                      || ':') = 0; -- uid nicht im String vorhanden

      -- Übernehmen der Eingabedaten  
                r_isr_oam_massnahmenkatalog.rsk_uid := pir_rsk_isr_oam_massnahmenkatalog.rsk_uid;
      -- Ergänzen der Anlagedaten aus dem verknüpften Risiko
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_massnahmenkatalog.inserted,
                    r_isr_oam_massnahmenkatalog.inserted_by
                from
                    isr_oam_risikoinventar
                where
                    rsk_uid = pir_rsk_isr_oam_massnahmenkatalog.rsk_uid;

                r_isr_oam_massnahmenkatalog.updated := sysdate;
                r_isr_oam_massnahmenkatalog.updated_by := pck_env.fv_user; 

      -- Einfügen der hinzugefügten Verknüpfungen
                for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
                    select
                        trim(regexp_substr(pir_rsk_isr_oam_massnahmenkatalog.massnahmen, '[^:]+', 1, level)) msn_uid
                    from
                        dual
                    connect by
                        instr(pir_rsk_isr_oam_massnahmenkatalog.massnahmen, ':', 1, level - 1) > 0
                    minus
            -- Ausscließen der bereits gespeicherten Verknüpfungen
                    select
                        to_char(msn_uid)
                    from
                        isr_oam_massnahmenkatalog
                    where
                        rsk_uid = pir_rsk_isr_oam_massnahmenkatalog.rsk_uid
                ) loop
                    if rsk.msn_uid is not null then
                        r_isr_oam_massnahmenkatalog.mnk_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                        r_isr_oam_massnahmenkatalog.msn_uid := rsk.msn_uid;
                        insert into isr_oam_massnahmenkatalog values r_isr_oam_massnahmenkatalog;
            --History--
                        r_isr_oam_massnahmenkatalog_hist.mnk_uid := r_isr_oam_massnahmenkatalog.mnk_uid;
                        r_isr_oam_massnahmenkatalog_hist.insert_info := 'Maßnahme wurde hinzugefügt';
                        rk_main.pck_isr_oam_massnahmenkatalog_hist_dml.p_insert(pior_massnahmenkatalog_hist => r_isr_oam_massnahmenkatalog_hist
                        );
                    end if;
                end loop;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_rsk_isr_oam_massnahmenkatalog);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        
---------------------------------------------------------------------------------------------------
/* Update-Alternative M. Schmenner */
    procedure p_update (
        pir_msn_isr_oam_massnahmenkatalog in msn_isr_oam_massnahmenkatalog,
        piv_art                           in varchar2
    ) is

        r_msn_isr_oam_massnahmenkatalog  msn_isr_oam_massnahmenkatalog;
        r_isr_oam_massnahmenkatalog      isr_oam_massnahmenkatalog%rowtype;
        r_isr_oam_massnahmenkatalog_hist isr_oam_massnahmenkatalog_hist%rowtype;

-- fuer exceptions        
        v_routine_name                   logs.routine_name%type;
        c_message                        clob;
    begin        
  -- fuer exceptions      
        v_routine_name := gcv_package_name || '.P_UPDATE';
        case piv_art
            when '<full>' then    
      -- Löschen der gelösten Verknüpfungen
                delete from isr_oam_massnahmenkatalog
                where
                        msn_uid = pir_msn_isr_oam_massnahmenkatalog.msn_uid
                    and instr(':'
                              || pir_msn_isr_oam_massnahmenkatalog.risiken
                              || ':', ':'
                                      || rsk_uid
                                      || ':') = 0; -- uid nicht im String vorhanden

      -- Übernehmen der Eingabedaten  
                r_isr_oam_massnahmenkatalog.msn_uid := pir_msn_isr_oam_massnahmenkatalog.msn_uid;
      -- Ergänzen der Anlagedaten aus dem verknüpften Risiko
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_massnahmenkatalog.inserted,
                    r_isr_oam_massnahmenkatalog.inserted_by
                from
                    isr_oam_massnahme
                where
                    msn_uid = pir_msn_isr_oam_massnahmenkatalog.msn_uid;

                r_isr_oam_massnahmenkatalog.updated := sysdate;
                r_isr_oam_massnahmenkatalog.updated_by := pck_env.fv_user; 

      -- Einfügen der hinzugefügten Verknüpfungen
                for msn in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
                    select
                        trim(regexp_substr(pir_msn_isr_oam_massnahmenkatalog.risiken, '[^:]+', 1, level)) rsk_uid
                    from
                        dual
                    connect by
                        instr(pir_msn_isr_oam_massnahmenkatalog.risiken, ':', 1, level - 1) > 0
                    minus
            -- Ausscließen der bereits gespeicherten Verknüpfungen
                    select
                        to_char(rsk_uid)
                    from
                        isr_oam_massnahmenkatalog
                    where
                        msn_uid = pir_msn_isr_oam_massnahmenkatalog.msn_uid
                ) loop
                    if msn.rsk_uid is not null then
                        r_isr_oam_massnahmenkatalog.mnk_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
                        r_isr_oam_massnahmenkatalog.rsk_uid := msn.rsk_uid;
                        insert into isr_oam_massnahmenkatalog values r_isr_oam_massnahmenkatalog;
            --History--
                        r_isr_oam_massnahmenkatalog_hist.mnk_uid := r_isr_oam_massnahmenkatalog.mnk_uid;
                        r_isr_oam_massnahmenkatalog_hist.insert_info := 'Risiko wurde hinzugefügt';
                        rk_main.pck_isr_oam_massnahmenkatalog_hist_dml.p_insert(pior_massnahmenkatalog_hist => r_isr_oam_massnahmenkatalog_hist
                        );
                    end if;
                end loop;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then      
  -- Fehlerprotokollierung      
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_msn_isr_oam_massnahmenkatalog);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;        
---------------------------------------------------------------------------------------------------

    procedure p_delete_for_rsk (
        pin_rsk_uid in isr_oam_massnahmenkatalog.rsk_uid%type
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
        delete from isr_oam_massnahmenkatalog
        where
            rsk_uid = pin_rsk_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_massnahmenkatalog! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_massnahmenkatalog! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_rsk;

    procedure p_delete_for_msn (
        pin_msn_uid in isr_oam_massnahmenkatalog.msn_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_msn_uid: ' || to_char(pin_msn_uid);
        delete from isr_oam_massnahmenkatalog
        where
            msn_uid = pin_msn_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_massnahmenkatalog! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_massnahmenkatalog! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_msn;

    procedure p_delete_for_msn_rsk (
        pin_msn_uid in isr_oam_massnahmenkatalog.msn_uid%type,
        pin_rsk_uid in isr_oam_massnahmenkatalog.rsk_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_msn_uid: ' || to_char(pin_msn_uid);
        delete from isr_oam_massnahmenkatalog
        where
                msn_uid = pin_msn_uid
            and rsk_uid = pin_rsk_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_massnahmenkatalog! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_massnahmenkatalog! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete_for_msn_rsk;

end pck_isr_oam_massnahmenkatalog_dml;
/


-- sqlcl_snapshot {"hash":"f82159701dfc97e1da18b3ec7475df1fc792f9e4","type":"PACKAGE_BODY","name":"PCK_ISR_OAM_MASSNAHMENKATALOG_DML","schemaName":"RK_MAIN","sxml":""}