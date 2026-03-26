create or replace editionable trigger awh_main.trg_awh_proz_erheb_5 after
    delete or update on awh_main.awh_proz_erheb_5
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
    ) values ( 'AWH_PROZ_ERHEB_5',
               to_char(:old.ap5_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.kpd_lfd_nr),
               to_char(:old.ap5_timestamp),
               :old.ap5_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_5 enable;


-- sqlcl_snapshot {"hash":"dfe070e07cdc48dfdbfddf12c28d2ed1ba8b6673","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_5","schemaName":"AWH_MAIN","sxml":""}