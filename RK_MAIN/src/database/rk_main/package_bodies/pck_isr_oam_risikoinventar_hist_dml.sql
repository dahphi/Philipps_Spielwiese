create or replace package body rk_main.pck_isr_oam_risikoinventar_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_risikoinventar_hist%rowtype,
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
            v_retval := '<table><tr><th>ISR_OAM_RISIKOINVENTAR_HIST</th><th>Column</th></tr>'
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
        pior_isr_oam_risikoinventar_hist in out isr_oam_risikoinventar_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name                logs.routine_name%type;
        c_message                     clob;
        r_isr_oam_risikoinventar_hist isr_oam_risikoinventar_hist%rowtype;
        r_isr_oam_risikoinventar      isr_oam_risikoinventar%rowtype;
        v_version                     number;
    begin
        select
            *
        into r_isr_oam_risikoinventar
        from
            isr_oam_risikoinventar
        where
            rsk_uid = pior_isr_oam_risikoinventar_hist.rsk_uid;

        select
            max(rskh_version)
        into v_version
        from
            isr_oam_risikoinventar_hist
        where
            rsk_uid = pior_isr_oam_risikoinventar_hist.rsk_uid;

        if v_version >= 1 then
            v_version := v_version + 1;
        else
            v_version := 1;
        end if;

  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_isr_oam_risikoinventar_hist.rskh_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        r_isr_oam_risikoinventar_hist.rsk_uid := r_isr_oam_risikoinventar.rsk_uid;
        r_isr_oam_risikoinventar_hist.rsk_risikotitel := r_isr_oam_risikoinventar.rsk_risikotitel;
        r_isr_oam_risikoinventar_hist.rsk_beschreibung := r_isr_oam_risikoinventar.rsk_beschreibung;
        r_isr_oam_risikoinventar_hist.gef_uid := r_isr_oam_risikoinventar.gef_uid;
        r_isr_oam_risikoinventar_hist.abweichung_sollzustand := r_isr_oam_risikoinventar.abweichung_sollzustand;
        r_isr_oam_risikoinventar_hist.rkt_uid := r_isr_oam_risikoinventar.rkt_uid;
        r_isr_oam_risikoinventar_hist.inserted := r_isr_oam_risikoinventar.inserted;
        r_isr_oam_risikoinventar_hist.updated := r_isr_oam_risikoinventar.updated;
        r_isr_oam_risikoinventar_hist.inserted_by := r_isr_oam_risikoinventar.inserted_by;
        r_isr_oam_risikoinventar_hist.updated_by := r_isr_oam_risikoinventar.updated_by;
        r_isr_oam_risikoinventar_hist.netto1_ews_uid := r_isr_oam_risikoinventar.netto1_ews_uid;
        r_isr_oam_risikoinventar_hist.netto1_auw_uid := r_isr_oam_risikoinventar.netto1_auw_uid;
        r_isr_oam_risikoinventar_hist.netto2_ews_uid := r_isr_oam_risikoinventar.netto2_ews_uid;
        r_isr_oam_risikoinventar_hist.netto2_auw_uid := r_isr_oam_risikoinventar.netto2_auw_uid;
        r_isr_oam_risikoinventar_hist.ska_uid := r_isr_oam_risikoinventar.ska_uid;
        r_isr_oam_risikoinventar_hist.rsk_unit_risikotraeger := r_isr_oam_risikoinventar.rsk_unit_risikotraeger;
        r_isr_oam_risikoinventar_hist.ris_uid := r_isr_oam_risikoinventar.ris_uid;
        r_isr_oam_risikoinventar_hist.rsk_accepted_date := r_isr_oam_risikoinventar.rsk_accepted_date;
        r_isr_oam_risikoinventar_hist.rsk_accepted_san := r_isr_oam_risikoinventar.rsk_accepted_san;
        r_isr_oam_risikoinventar_hist.rskh_version := v_version;
        r_isr_oam_risikoinventar_hist.rskh_inserted := sysdate;
  --pior_isr_oam_risikoinventar_hist.RSKH_INSERTED                := SYSDATE;

        insert into isr_oam_risikoinventar_hist values r_isr_oam_risikoinventar_hist;-- RETURNING RSKH_UID INTO pior_isr_oam_risikoinventar_hist.RSKH_UID;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_risikoinventar_hist! Parameter: ' || fv_print(pir_row => pior_isr_oam_risikoinventar_hist
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

end pck_isr_oam_risikoinventar_hist_dml;
/


-- sqlcl_snapshot {"hash":"543601103c893897239fad6e8d675bd0cd3b1873","type":"PACKAGE_BODY","name":"PCK_ISR_OAM_RISIKOINVENTAR_HIST_DML","schemaName":"RK_MAIN","sxml":""}