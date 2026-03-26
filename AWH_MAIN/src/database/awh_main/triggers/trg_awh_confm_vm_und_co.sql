create or replace editionable trigger awh_main.trg_awh_confm_vm_und_co after
    delete or update on awh_main.awh_confm_vm_und_co
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_col3_val,
        log_col4_val,
        log_col5_val,
        log_col6_val,
        log_col7_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_CONFM_VM_UND_CO',
               to_char(:old.asy_lfd_nr),
               :old.vvg_gvb,
               :old.vvg_vms,
               :old.vvg_geraet,
               :old.vvg_was,
               to_char(:old.vvg_timestamp),
               :old.vvg_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_confm_vm_und_co enable;


-- sqlcl_snapshot {"hash":"37585959c35abf86558254fa8fa72f18ed52bbd5","type":"TRIGGER","name":"TRG_AWH_CONFM_VM_UND_CO","schemaName":"AWH_MAIN","sxml":""}