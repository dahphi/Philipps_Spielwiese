create or replace editionable trigger awh_main.trg_awh_infosec_taskomment after
    delete or update on awh_main.awh_infosec_taskomment
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_col3_val,
        log_col4_val,
        log_col5_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_TASKOMMENT',
               to_char(:old.asy_lfd_nr),
               :old.tsk_vet,
               :old.tsk_int,
               :old.tsk_vef,
               :old.tsk_aut,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_taskomment enable;


-- sqlcl_snapshot {"hash":"68d291ae2d7dec2d7b26369e8a06916917cbb95b","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TASKOMMENT","schemaName":"AWH_MAIN","sxml":""}