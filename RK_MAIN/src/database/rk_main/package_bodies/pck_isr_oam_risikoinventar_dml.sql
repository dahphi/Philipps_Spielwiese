create or replace package body rk_main.pck_isr_oam_risikoinventar_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_risikoinventar%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'rsk_uid = '
                        || to_char(pir_row.rsk_uid)
                        || cv_sep
                        || ', rsk_risikotitel = '
                        || pir_row.rsk_risikotitel
                        || cv_sep
                        || ', rsk_beschreibung = '
                        || pir_row.rsk_beschreibung
                        || cv_sep
                        || ', gef_uid = '
                        || to_char(pir_row.gef_uid)
                        || cv_sep
                        || ', abweichung_sollzustand = '
                        || pir_row.abweichung_sollzustand
                        || cv_sep
                        || ', rkt_uid = '
                        || to_char(pir_row.rkt_uid)
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
                        || ', netto1_ews_uid = '
                        || to_char(pir_row.netto1_ews_uid)
                        || cv_sep
                        || ', netto1_auw_uid = '
                        || to_char(pir_row.netto1_auw_uid)
                        || cv_sep
                        || ', netto2_ews_uid = '
                        || to_char(pir_row.netto2_ews_uid)
                        || cv_sep
                        || ', netto2_auw_uid = '
                        || to_char(pir_row.netto2_auw_uid)
                        || cv_sep
                        || ', ska_uid = '
                        || to_char(pir_row.ska_uid)
                        || cv_sep
                --|| ', ekq_uids = '                || pir_row.ekq_uids           || cv_sep
                        || ', rsk_workflow_status = '
                        || pir_row.rsk_workflow_status
                        || cv_sep
                        || ', rsk_unit_risikotraeger = '
                        || pir_row.rsk_unit_risikotraeger
                        || cv_sep
                        || ', ris_uid = '
                        || to_char(pir_row.ris_uid)
                        || cv_sep
                        || ', rsk_accepted_date = '
                        || to_char(pir_row.rsk_accepted_date, 'DD.MM.YYYY')
                        || cv_sep
                        || ', rsk_accepted_san = '
                        || pir_row.rsk_accepted_san
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
            v_retval := '<table><tr><th>ISR_OAM_RISIKOINVENTAR</th><th>Column</th></tr>'
                        || '<tr><td>rsk_uid</td><td>'
                        || to_char(pir_row.rsk_uid)
                        || '</td></tr>'
                        || '<tr><td>rsk_risikotitel</td><td>'
                        || pir_row.rsk_risikotitel
                        || '</td></tr>'
                        || '<tr><td>rsk_beschreibung</td><td>'
                        || pir_row.rsk_beschreibung
                        || '</td></tr>'
                        || '<tr><td>gef_uid</td><td>'
                        || to_char(pir_row.gef_uid)
                        || '</td></tr>'
                        || '<tr><td>abweichung_sollzustand</td><td>'
                        || pir_row.abweichung_sollzustand
                        || '</td></tr>'
                        || '<tr><td>rkt_uid</td><td>'
                        || to_char(pir_row.rkt_uid)
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
                        || '<tr><td>netto1_ews_uid</td><td>'
                        || to_char(pir_row.netto1_ews_uid)
                        || '</td></tr>'
                        || '<tr><td>netto1_auw_uid</td><td>'
                        || to_char(pir_row.netto1_auw_uid)
                        || '</td></tr>'
                        || '<tr><td>netto2_ews_uid</td><td>'
                        || to_char(pir_row.netto2_ews_uid)
                        || '</td></tr>'
                        || '<tr><td>netto2_auw_uid</td><td>'
                        || to_char(pir_row.netto2_auw_uid)
                        || '</td></tr>'
                        || '<tr><td>ska_uid</td><td>'
                        || to_char(pir_row.ska_uid)
                        || '</td></tr>'
               -- || '<tr><td>ekq_uids</td><td>'                || pir_row.ekq_uids               || '</td></tr>'
                        || '<tr><td>rsk_workflow_status</td><td>'
                        || pir_row.rsk_workflow_status
                        || '</td></tr>'
                        || '<tr><td>rsk_unit_risikotraeger</td><td>'
                        || pir_row.rsk_unit_risikotraeger
                        || '</td></tr>'
                        || '<tr><td>ris_uid</td><td>'
                        || to_char(pir_row.ris_uid)
                        || '</td></tr>'
                        || '<tr><td>rsk_accepted_date</td><td>'
                        || to_char(pir_row.rsk_accepted_date, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>rsk_accepted_san</td><td>'
                        || pir_row.rsk_accepted_san
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_risikoinventar in out isr_oam_risikoinventar%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_risikoinventar.inserted := sysdate;
        pior_isr_oam_risikoinventar.inserted_by := pck_env.fv_user;
        insert into isr_oam_risikoinventar values pior_isr_oam_risikoinventar returning rsk_uid into pior_isr_oam_risikoinventar.rsk_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_risikoinventar! Parameter: ' || fv_print(pir_row => pior_isr_oam_risikoinventar
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_risikoinventar in isr_oam_risikoinventar%rowtype
    ) is
        r_isr_oam_risikoinventar isr_oam_risikoinventar%rowtype;

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_risikoinventar := pir_isr_oam_risikoinventar;
        r_isr_oam_risikoinventar.inserted := sysdate;
        r_isr_oam_risikoinventar.updated := sysdate;
        r_isr_oam_risikoinventar.inserted_by := pck_env.fv_user;
        r_isr_oam_risikoinventar.updated_by := pck_env.fv_user;
        merge into isr_oam_risikoinventar
        using dual on ( rsk_uid = r_isr_oam_risikoinventar.rsk_uid )
        when matched then update
        set rsk_risikotitel = r_isr_oam_risikoinventar.rsk_risikotitel,
            rsk_beschreibung = r_isr_oam_risikoinventar.rsk_beschreibung,
            gef_uid = r_isr_oam_risikoinventar.gef_uid,
            abweichung_sollzustand = r_isr_oam_risikoinventar.abweichung_sollzustand,
            rkt_uid = r_isr_oam_risikoinventar.rkt_uid,
            updated = r_isr_oam_risikoinventar.updated,
            updated_by = r_isr_oam_risikoinventar.updated_by,
            netto1_ews_uid = r_isr_oam_risikoinventar.netto1_ews_uid,
            netto1_auw_uid = r_isr_oam_risikoinventar.netto1_auw_uid
     -- , netto2_ews_uid           = r_isr_oam_risikoinventar.netto2_ews_uid
     -- , netto2_auw_uid           = r_isr_oam_risikoinventar.netto2_auw_uid
            ,
            netto2_ews_uid =
            case
                when r_isr_oam_risikoinventar.ris_uid = '269631043604196086024472092990263820296' then
                    null
                else
                    r_isr_oam_risikoinventar.netto2_ews_uid
            end,
            netto2_auw_uid =
            case
                when r_isr_oam_risikoinventar.ris_uid = '269631043604196086024472092990263820296' then
                    null
                else
                    r_isr_oam_risikoinventar.netto2_auw_uid
            end,
            ska_uid = r_isr_oam_risikoinventar.ska_uid
      --, ekq_uids                 = r_isr_oam_risikoinventar.ekq_uids
            ,
            rsk_workflow_status = r_isr_oam_risikoinventar.rsk_workflow_status,
            rsk_unit_risikotraeger = r_isr_oam_risikoinventar.rsk_unit_risikotraeger,
            ris_uid = r_isr_oam_risikoinventar.ris_uid,
            rsk_accepted_date = r_isr_oam_risikoinventar.rsk_accepted_date,
            rsk_accepted_san = r_isr_oam_risikoinventar.rsk_accepted_san
        when not matched then
        insert (
            rsk_risikotitel,
            rsk_beschreibung,
            gef_uid,
            abweichung_sollzustand,
            rkt_uid,
            inserted,
            inserted_by,
            netto1_ews_uid,
            netto1_auw_uid,
            netto2_ews_uid,
            netto2_auw_uid,
            ska_uid
      --, ekq_uids
            ,
            rsk_workflow_status,
            rsk_unit_risikotraeger,
            ris_uid,
            rsk_accepted_date,
            rsk_accepted_san )
        values
            ( r_isr_oam_risikoinventar.rsk_risikotitel,
              r_isr_oam_risikoinventar.rsk_beschreibung,
              r_isr_oam_risikoinventar.gef_uid,
              r_isr_oam_risikoinventar.abweichung_sollzustand,
              r_isr_oam_risikoinventar.rkt_uid,
              r_isr_oam_risikoinventar.inserted,
              r_isr_oam_risikoinventar.inserted_by,
              r_isr_oam_risikoinventar.netto1_ews_uid,
              r_isr_oam_risikoinventar.netto1_auw_uid,
              r_isr_oam_risikoinventar.netto2_ews_uid,
              r_isr_oam_risikoinventar.netto2_auw_uid,
              r_isr_oam_risikoinventar.ska_uid
     -- , r_isr_oam_risikoinventar.ekq_uids
              ,
              r_isr_oam_risikoinventar.rsk_workflow_status,
              r_isr_oam_risikoinventar.rsk_unit_risikotraeger,
              r_isr_oam_risikoinventar.ris_uid,
              r_isr_oam_risikoinventar.rsk_accepted_date,
              r_isr_oam_risikoinventar.rsk_accepted_san );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_risikoinventar);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_oam_risikoinventar in isr_oam_risikoinventar%rowtype,
        piv_art                    in varchar2
    ) is
        r_isr_oam_risikoinventar      isr_oam_risikoinventar%rowtype;
        r_isr_oam_risikoinventar_hist isr_oam_risikoinventar_hist%rowtype;
  -- fuer exceptions
        v_routine_name                logs.routine_name%type;
        c_message                     clob;
    begin

  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_oam_risikoinventar.rsk_risikotitel := pir_isr_oam_risikoinventar.rsk_risikotitel;
        r_isr_oam_risikoinventar.rsk_beschreibung := pir_isr_oam_risikoinventar.rsk_beschreibung;
        r_isr_oam_risikoinventar.gef_uid := pir_isr_oam_risikoinventar.gef_uid;
        r_isr_oam_risikoinventar.abweichung_sollzustand := pir_isr_oam_risikoinventar.abweichung_sollzustand;
        r_isr_oam_risikoinventar.rkt_uid := pir_isr_oam_risikoinventar.rkt_uid;
        r_isr_oam_risikoinventar.updated := sysdate;
        r_isr_oam_risikoinventar.updated_by := pck_env.fv_user;
        r_isr_oam_risikoinventar.netto1_ews_uid := pir_isr_oam_risikoinventar.netto1_ews_uid;
        r_isr_oam_risikoinventar.netto1_auw_uid := pir_isr_oam_risikoinventar.netto1_auw_uid;
        r_isr_oam_risikoinventar.netto2_ews_uid := pir_isr_oam_risikoinventar.netto2_ews_uid;
        r_isr_oam_risikoinventar.netto2_auw_uid := pir_isr_oam_risikoinventar.netto2_auw_uid;
        r_isr_oam_risikoinventar.ska_uid := pir_isr_oam_risikoinventar.ska_uid;
        r_isr_oam_risikoinventar.rsk_workflow_status := pir_isr_oam_risikoinventar.rsk_workflow_status;
        r_isr_oam_risikoinventar.rsk_unit_risikotraeger := pir_isr_oam_risikoinventar.rsk_unit_risikotraeger;
        r_isr_oam_risikoinventar.ris_uid := pir_isr_oam_risikoinventar.ris_uid;
        r_isr_oam_risikoinventar.rsk_accepted_date := pir_isr_oam_risikoinventar.rsk_accepted_date;
        r_isr_oam_risikoinventar.rsk_accepted_san := pir_isr_oam_risikoinventar.rsk_accepted_san;
        case piv_art
            when '<replace>' then
                update isr_oam_risikoinventar
                set
                    rsk_uid = pir_isr_oam_risikoinventar.rsk_uid
                where
                    rsk_uid = pir_isr_oam_risikoinventar.rsk_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_oam_risikoinventar := pir_isr_oam_risikoinventar;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_risikoinventar.inserted,
                    r_isr_oam_risikoinventar.inserted_by
                from
                    isr_oam_risikoinventar
                where
                    rsk_uid = pir_isr_oam_risikoinventar.rsk_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_oam_risikoinventar.updated := sysdate;
                r_isr_oam_risikoinventar.updated_by := pck_env.fv_user;
                update isr_oam_risikoinventar
                set
                    row = r_isr_oam_risikoinventar
                where
                    rsk_uid = pir_isr_oam_risikoinventar.rsk_uid;  
      --HISTORY--
                r_isr_oam_risikoinventar_hist.rsk_uid := pir_isr_oam_risikoinventar.rsk_uid;
                pck_isr_oam_risikoinventar_hist_dml.p_insert(pior_isr_oam_risikoinventar_hist => r_isr_oam_risikoinventar_hist);
            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_risikoinventar);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;


---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_rsk_uid in isr_oam_risikoinventar.rsk_uid%type
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
        delete from isr_risiko_erkenntnisquelle
        where
            rsk_uid = pin_rsk_uid;

        delete from isr_oam_risikoinventar
        where
            rsk_uid = pin_rsk_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_risikoinventar! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_risikoinventar! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_oam_risikoinventar_dml;
/


-- sqlcl_snapshot {"hash":"b76dcbe1459359e2e09b1aa5818f385153863eb6","type":"PACKAGE_BODY","name":"PCK_ISR_OAM_RISIKOINVENTAR_DML","schemaName":"RK_MAIN","sxml":""}