create or replace editionable trigger awh_main.trg_awh_proz_erheb_5_bes_kat after
    delete or update on awh_main.awh_proz_erheb_5_bes_kat
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
    ) values ( 'AWH_PROZ_ERHEB_5_BES_KAT',
               to_char(:old.ap5bk_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.kpb_lfd_nr),
               to_char(:old.ap5bk_timestamp),
               :old.ap5bk_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_5_bes_kat enable;


-- sqlcl_snapshot {"hash":"9cef5d18569fd601a34b2779eb9cc378307aeb13","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_5_BES_KAT","schemaName":"AWH_MAIN","sxml":""}