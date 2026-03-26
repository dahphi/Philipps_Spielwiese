create or replace editionable trigger awh_main.trg_awh_proz_erheb_4 after
    delete or update on awh_main.awh_proz_erheb_4
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
    ) values ( 'AWH_PROZ_ERHEB_4',
               to_char(:old.ap4_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.bpg_lfd_nr),
               to_char(:old.ap4_timestamp),
               :old.ap4_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_4 enable;


-- sqlcl_snapshot {"hash":"315edee6385b0ff4932439f8bfd48ba0fa1d6bd5","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_4","schemaName":"AWH_MAIN","sxml":""}