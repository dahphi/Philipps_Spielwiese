create or replace editionable trigger awh_main.trg_awh_proz_erheb after
    delete or update on awh_main.awh_proz_erheb
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
    ) values ( 'AWH_PROZ_ERHEB',
               to_char(:old.ape_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.ape_timestamp),
               :old.ape_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb enable;


-- sqlcl_snapshot {"hash":"c20847b696d5bc6726a7f86f5fbdf2fa83c3a353","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB","schemaName":"AWH_MAIN","sxml":""}