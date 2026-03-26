create or replace editionable trigger awh_main.trg_awh_infosec_sbkomment after
    delete or update on awh_main.awh_infosec_sbkomment
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
    ) values ( 'AWH_INFOSEC_SBKOMMENT',
               to_char(:old.asy_lfd_nr),
               :old.sbk_vet,
               :old.sbk_int,
               :old.sbk_vef,
               :old.sbk_aut,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_sbkomment enable;


-- sqlcl_snapshot {"hash":"dae1dfaa58c24c9c26d9aede35b23ce89cac5298","type":"TRIGGER","name":"TRG_AWH_INFOSEC_SBKOMMENT","schemaName":"AWH_MAIN","sxml":""}