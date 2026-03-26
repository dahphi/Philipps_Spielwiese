-- liquibase formatted sql
-- changeset RK_MAIN:1774561692593 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_oam_adressat_dml_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_oam_adressat_dml_hist.sql:null:95e1f86bc8e5283a2ea57ad4a54e0c3227799fd8:create

create or replace package body rk_main.pck_isr_oam_adressat_dml_hist as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_adressat_hist%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'adr_uid = '
                        || to_char(pir_row.adr_uid)
                        || cv_sep
                        || ', msn_uid = '
                        || to_char(pir_row.msn_uid)
                        || cv_sep
                        || ', adr_rolle = '
                        || pir_row.adr_rolle
                        || cv_sep
                        || ', adr_responsible = '
                        || to_char(pir_row.adr_responsible)
                        || cv_sep
                        || ', adr_accountable = '
                        || to_char(pir_row.adr_accountable)
                        || cv_sep
                        || ', adr_consulted = '
                        || to_char(pir_row.adr_consulted)
                        || cv_sep
                        || ', adr_informed = '
                        || to_char(pir_row.adr_informed)
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
                        || ', adr_san = '
                        || pir_row.adr_san
                        || cv_sep
                        || ', adr_bereich = '
                        || pir_row.adr_bereich
                        || cv_sep
                        || ', adr_oe = '
                        || pir_row.adr_oe
                        || cv_sep
                        || ', adr_support = '
                        || to_char(pir_row.adr_support)
                        || cv_sep
                        || ', ADRH_INSERTED = '
                        || to_char(pir_row.adrh_inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', ADRH_INSERTED_BY = '
                        || pir_row.adrh_inserted_by
                        || cv_sep
                        || ', ADRH_INFO = '
                        || pir_row.adrh_info
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
            v_retval := '<table><tr><th>ISR_OAM_ADRESSAT</th><th>Column</th></tr>'
                        || '<tr><td>adr_uid</td><td>'
                        || to_char(pir_row.adr_uid)
                        || '</td></tr>'
                        || '<tr><td>msn_uid</td><td>'
                        || to_char(pir_row.msn_uid)
                        || '</td></tr>'
                        || '<tr><td>adr_rolle</td><td>'
                        || pir_row.adr_rolle
                        || '</td></tr>'
                        || '<tr><td>adr_responsible</td><td>'
                        || to_char(pir_row.adr_responsible)
                        || '</td></tr>'
                        || '<tr><td>adr_accountable</td><td>'
                        || to_char(pir_row.adr_accountable)
                        || '</td></tr>'
                        || '<tr><td>adr_consulted</td><td>'
                        || to_char(pir_row.adr_consulted)
                        || '</td></tr>'
                        || '<tr><td>adr_informed</td><td>'
                        || to_char(pir_row.adr_informed)
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
                        || '<tr><td>adr_san</td><td>'
                        || pir_row.adr_san
                        || '</td></tr>'
                        || '<tr><td>adr_bereich</td><td>'
                        || pir_row.adr_bereich
                        || '</td></tr>'
                        || '<tr><td>adr_oe</td><td>'
                        || pir_row.adr_oe
                        || '</td></tr>'
                        || '<tr><td>adr_support</td><td>'
                        || to_char(pir_row.adr_support)
                        || '</td></tr>'
                        || '<tr><td>ADRH_INSERTED</td><td>'
                        || to_char(pir_row.adrh_inserted)
                        || '</td></tr>'
                        || '<tr><td>ADRH_INSERTED_BY</td><td>'
                        || pir_row.adrh_inserted_by
                        || '</td></tr>'
                        || '<tr><td>ADRH_INFO</td><td>'
                        || pir_row.adrh_info
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;
---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_adressat_hist in out isr_oam_adressat%rowtype,
        pi_history_type            in varchar2
    ) is

  -- fuer exceptions
        v_routine_name          logs.routine_name%type;
        c_message               clob;
        r_isr_oam_adressat_hist isr_oam_adressat_hist%rowtype;
        r_isr_oam_adressat      isr_oam_adressat%rowtype;
    begin
        select
            *
        into r_isr_oam_adressat
        from
            isr_oam_adressat
        where
            adr_uid = pior_isr_oam_adressat_hist.adr_uid;

  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_isr_oam_adressat_hist.adrh_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        r_isr_oam_adressat_hist.adr_uid := r_isr_oam_adressat.adr_uid;
        r_isr_oam_adressat_hist.msn_uid := r_isr_oam_adressat.msn_uid;
        r_isr_oam_adressat_hist.adr_rolle := r_isr_oam_adressat.adr_rolle;
        r_isr_oam_adressat_hist.adr_responsible := r_isr_oam_adressat.adr_responsible;
        r_isr_oam_adressat_hist.adr_accountable := r_isr_oam_adressat.adr_accountable;
        r_isr_oam_adressat_hist.adr_consulted := r_isr_oam_adressat.adr_consulted;
        r_isr_oam_adressat_hist.adr_informed := r_isr_oam_adressat.adr_informed;
        r_isr_oam_adressat_hist.inserted := r_isr_oam_adressat.inserted;
        r_isr_oam_adressat_hist.updated := r_isr_oam_adressat.updated;
        r_isr_oam_adressat_hist.inserted_by := r_isr_oam_adressat.inserted_by;
        r_isr_oam_adressat_hist.updated_by := r_isr_oam_adressat.updated_by;
        r_isr_oam_adressat_hist.adr_san := r_isr_oam_adressat.adr_san;
        r_isr_oam_adressat_hist.adr_bereich := r_isr_oam_adressat.adr_bereich;
        r_isr_oam_adressat_hist.adr_oe := r_isr_oam_adressat.adr_oe;
        r_isr_oam_adressat_hist.adr_support := r_isr_oam_adressat.adr_support;
        r_isr_oam_adressat_hist.adrh_inserted := sysdate;
        r_isr_oam_adressat_hist.adrh_inserted_by := pck_env.fv_user;
        r_isr_oam_adressat_hist.adrh_info := pi_history_type;
        insert into isr_oam_adressat_hist values r_isr_oam_adressat_hist;-- RETURNING ADRH_UID INTO pior_ISR_OAM_ADRESSAT_HIST.ADRH_UID;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ISR_OAM_ADRESSAT_HIST! Parameter: ' || fv_print( pir_row => pior_ISR_OAM_ADRESSAT_HIST );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
    --RAISE;
            null;
    end p_insert;

end pck_isr_oam_adressat_dml_hist;
/

