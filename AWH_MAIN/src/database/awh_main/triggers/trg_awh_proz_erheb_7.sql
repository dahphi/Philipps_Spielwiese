create or replace editionable trigger awh_main.trg_awh_proz_erheb_7 after
    delete or update on awh_main.awh_proz_erheb_7
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
        log_timestamp,
        log_user
    ) values ( 'AWH_PROZ_ERHEB_7',
               to_char(:old.ap7_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.exs_lfd_nr),
               :old.ap7_beschreibung,
               to_char(:old.ap7_timestamp),
               :old.ap7_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_7 enable;


-- sqlcl_snapshot {"hash":"a1ae97dd69674aa79cdcb4b733d9bed1699aca02","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_7","schemaName":"AWH_MAIN","sxml":""}