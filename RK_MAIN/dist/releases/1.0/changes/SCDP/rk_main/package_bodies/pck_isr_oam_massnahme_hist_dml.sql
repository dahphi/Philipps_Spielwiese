-- liquibase formatted sql
-- changeset RK_MAIN:1774561692807 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_oam_massnahme_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_oam_massnahme_hist_dml.sql:null:77c52316b4bdb0b8c8205136a51c5e34432da997:create

create or replace package body rk_main.pck_isr_oam_massnahme_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_massnahme_hist%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'MSN_UID = '
                        || to_char(pir_row.msn_uid)
                        || cv_sep
                        || ', MSN_TITEL = '
                        || pir_row.msn_titel
                        || cv_sep
                        || ', MSN_BESCHREIBUNG = '
                        || pir_row.msn_beschreibung
                        || cv_sep
                        || ', MSN_INTERN = '
                        || to_char(pir_row.msn_intern)
                        || cv_sep
                        || ', MKA_UID = '
                        || to_char(pir_row.mka_uid)
                        || cv_sep
                        || ', INSERTED = '
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', UPDATED = '
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', INSERTED_BY = '
                        || pir_row.inserted_by
                        || cv_sep
                        || ', UPDATED_BY = '
                        || pir_row.updated_by
                        || cv_sep
                        || ', USS_UID = '
                        || to_char(pir_row.uss_uid)
                        || cv_sep
                        || ', ZIELTERMIN = '
                        || to_char(pir_row.zieltermin, 'DD.MM.YYYY')
                        || cv_sep
                        || ', USS_READY_DATE = '
                        || to_char(pir_row.uss_ready_date, 'DD.MM.YYYY')
                        || cv_sep
                        || ', MKP_UID = '
                        || to_char(pir_row.mkp_uid)
                        || cv_sep
                        || ', MSN_STATUSBESCHREIBUNG = '
                        || pir_row.msn_statusbeschreibung
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
            v_retval := '<table><tr><th>ISR_OAM_MASSNAHME_HIST</th><th>Column</th></tr>'
                        || '<tr><td>msn_uid</td><td>'
                        || to_char(pir_row.msn_uid)
                        || '</td></tr>'
                        || '<tr><td>msn_titel</td><td>'
                        || pir_row.msn_titel
                        || '</td></tr>'
                        || '<tr><td>msn_beschreibung</td><td>'
                        || pir_row.msn_beschreibung
                        || '</td></tr>'
                        || '<tr><td>msn_intern</td><td>'
                        || to_char(pir_row.msn_intern)
                        || '</td></tr>'
                        || '<tr><td>mka_uid</td><td>'
                        || to_char(pir_row.mka_uid)
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
                        || '<tr><td>uss_uid</td><td>'
                        || to_char(pir_row.uss_uid)
                        || '</td></tr>'
                        || '<tr><td>zieltermin</td><td>'
                        || to_char(pir_row.zieltermin, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>uss_ready_date</td><td>'
                        || to_char(pir_row.uss_ready_date, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>mkp_uid</td><td>'
                        || to_char(pir_row.mkp_uid)
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_massnahme_hist in out isr_oam_massnahme_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
        r_isr_oam_massnahme_hist isr_oam_massnahme_hist%rowtype;
        r_isr_oam_massnahme      isr_oam_massnahme%rowtype;
        v_version                number;
    begin
        select
            *
        into r_isr_oam_massnahme
        from
            isr_oam_massnahme
        where
            msn_uid = pior_isr_oam_massnahme_hist.msn_uid;

        select
            max(msnh_version)
        into v_version
        from
            isr_oam_massnahme_hist
        where
            msn_uid = pior_isr_oam_massnahme_hist.msn_uid;

        if v_version >= 1 then
            v_version := v_version + 1;
        else
            v_version := 1;
        end if;

  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_isr_oam_massnahme_hist.msnh_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        r_isr_oam_massnahme_hist.msn_uid := r_isr_oam_massnahme.msn_uid;
        r_isr_oam_massnahme_hist.msn_titel := r_isr_oam_massnahme.msn_titel;
        r_isr_oam_massnahme_hist.msn_beschreibung := r_isr_oam_massnahme.msn_beschreibung;
        r_isr_oam_massnahme_hist.msn_intern := r_isr_oam_massnahme.msn_intern;
        r_isr_oam_massnahme_hist.mka_uid := r_isr_oam_massnahme.mka_uid;
        r_isr_oam_massnahme_hist.inserted := r_isr_oam_massnahme.inserted;
        r_isr_oam_massnahme_hist.updated := r_isr_oam_massnahme.updated;
        r_isr_oam_massnahme_hist.inserted_by := r_isr_oam_massnahme.inserted_by;
        r_isr_oam_massnahme_hist.updated_by := r_isr_oam_massnahme.updated_by;
        r_isr_oam_massnahme_hist.uss_uid := r_isr_oam_massnahme.uss_uid;
        r_isr_oam_massnahme_hist.zieltermin := r_isr_oam_massnahme.zieltermin;
        r_isr_oam_massnahme_hist.uss_ready_date := r_isr_oam_massnahme.uss_ready_date;
        r_isr_oam_massnahme_hist.mkp_uid := r_isr_oam_massnahme.mkp_uid;
        r_isr_oam_massnahme_hist.msn_statusbeschreibung := r_isr_oam_massnahme.msn_statusbeschreibung;
        r_isr_oam_massnahme_hist.msnh_version := v_version;
        r_isr_oam_massnahme_hist.msnh_inserted := sysdate;
        insert into isr_oam_massnahme_hist values r_isr_oam_massnahme_hist;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle ISR_OAM_MASSNAHME_HIST! Parameter: ' || fv_print(pir_row => pior_isr_oam_massnahme_hist
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

end pck_isr_oam_massnahme_hist_dml;
/

