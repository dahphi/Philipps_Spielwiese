create or replace package body rk_main.pck_isr_oam_massnahmenkatalog_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_massnahmenkatalog_hist in out isr_oam_massnahmenkatalog_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name                   logs.routine_name%type;
        c_message                        clob;
        r_isr_oam_massnahmenkatalog      isr_oam_massnahmenkatalog%rowtype;
        r_isr_oam_massnahmenkatalog_hist isr_oam_massnahmenkatalog_hist%rowtype;
    begin
        select
            *
        into r_isr_oam_massnahmenkatalog
        from
            isr_oam_massnahmenkatalog
        where
            mnk_uid = pior_massnahmenkatalog_hist.mnk_uid;

  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_isr_oam_massnahmenkatalog_hist.mnkh_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        r_isr_oam_massnahmenkatalog_hist.mnk_uid := r_isr_oam_massnahmenkatalog.mnk_uid;
        r_isr_oam_massnahmenkatalog_hist.rsk_uid := r_isr_oam_massnahmenkatalog.rsk_uid;
        r_isr_oam_massnahmenkatalog_hist.msn_uid := r_isr_oam_massnahmenkatalog.msn_uid;
        r_isr_oam_massnahmenkatalog_hist.inserted := r_isr_oam_massnahmenkatalog.inserted;
        r_isr_oam_massnahmenkatalog_hist.updated := r_isr_oam_massnahmenkatalog.updated;
        r_isr_oam_massnahmenkatalog_hist.inserted_by := r_isr_oam_massnahmenkatalog.inserted_by;
        r_isr_oam_massnahmenkatalog_hist.updated_by := r_isr_oam_massnahmenkatalog.updated_by;
        r_isr_oam_massnahmenkatalog_hist.insert_info := pior_massnahmenkatalog_hist.insert_info;
        r_isr_oam_massnahmenkatalog_hist.mnkh_inserted := sysdate;
        r_isr_oam_massnahmenkatalog_hist.mnkh_inserted_by := pck_env.fv_user;
        insert into isr_oam_massnahmenkatalog_hist values r_isr_oam_massnahmenkatalog_hist;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ISR_OAM_MASSNAHMENKATALOG_hist! Parameter: ' || fv_print( pir_row => pior_MASSNAHMENKATALOG_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            null;
    end p_insert;

end pck_isr_oam_massnahmenkatalog_hist_dml;
/


-- sqlcl_snapshot {"hash":"e553eb6c4dcbc541a49a53965a89928f410506e6","type":"PACKAGE_BODY","name":"PCK_ISR_OAM_MASSNAHMENKATALOG_HIST_DML","schemaName":"RK_MAIN","sxml":""}