create or replace editionable trigger awh_main.trg_awh_infosec_tom_in after
    delete or update on awh_main.awh_infosec_tom_in
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_col3_val,
        log_col4_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_TOM_IN',
               to_char(:old.asy_lfd_nr),
               to_char(:old.tin_kontrolle),
               to_char(:old.adt_lfd_nr),
               to_char(:old.chm_lfd_nr),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_tom_in enable;


-- sqlcl_snapshot {"hash":"20a6c323e6cc7758f78d5597ba9d54974ab6b49e","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_IN","schemaName":"AWH_MAIN","sxml":""}