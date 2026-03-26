-- liquibase formatted sql
-- changeset RK_MAIN:1774555709910 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_asm_isr_assets_risiken_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_asm_isr_assets_risiken_hist_dml.sql:null:57e4153f227cec22c908a03adf266c57bbca16c6:create

create or replace package body rk_main.pck_asm_isr_assets_risiken_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_assets_risiken_hist in out asm_isr_assets_risiken_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name                logs.routine_name%type;
        c_message                     clob;
        r_asm_isr_assets_risiken      asm_isr_assets_risiken%rowtype;
        r_asm_isr_assets_risiken_hist asm_isr_assets_risiken_hist%rowtype;
    begin
        select
            *
        into r_asm_isr_assets_risiken
        from
            asm_isr_assets_risiken
        where
            asri_uid = pior_assets_risiken_hist.asri_uid;

  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        r_asm_isr_assets_risiken_hist.asrih_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        r_asm_isr_assets_risiken_hist.asri_uid := r_asm_isr_assets_risiken.asri_uid;
        r_asm_isr_assets_risiken_hist.ass_uid := r_asm_isr_assets_risiken.ass_uid;
        r_asm_isr_assets_risiken_hist.rsk_uid := r_asm_isr_assets_risiken.rsk_uid;
        r_asm_isr_assets_risiken_hist.inserted := r_asm_isr_assets_risiken.inserted;
        r_asm_isr_assets_risiken_hist.inserted_by := r_asm_isr_assets_risiken.inserted_by;
        r_asm_isr_assets_risiken_hist.updated_by := r_asm_isr_assets_risiken.updated_by;
        r_asm_isr_assets_risiken_hist.updated := r_asm_isr_assets_risiken.updated;
        r_asm_isr_assets_risiken_hist.insert_info := pior_assets_risiken_hist.insert_info;
        r_asm_isr_assets_risiken_hist.asrih_inserted := sysdate;
        r_asm_isr_assets_risiken_hist.asrih_inserted_by := pck_env.fv_user;
        insert into asm_isr_assets_risiken_hist values r_asm_isr_assets_risiken_hist;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ASM_ISR_ASSETS_RISIKEN_HIST! Parameter: ' || fv_print( pir_row => pior_ASSETS_RISIKEN_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            null;
    end p_insert;

end pck_asm_isr_assets_risiken_hist_dml;
/

