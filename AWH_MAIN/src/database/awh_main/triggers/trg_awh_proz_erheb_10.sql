create or replace editionable trigger awh_main.trg_awh_proz_erheb_10 after
    delete or update on awh_main.awh_proz_erheb_10
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
        log_col8_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_PROZ_ERHEB_10',
               to_char(:old.ap10_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.ap10_verw_tom),
               to_char(:old.ap10_verf_reg_ueb),
               to_char(:old.ap10_datenschutzanw),
               :old.ap10_sonst,
               to_char(:old.ap10_timestamp),
               :old.ap10_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_10 enable;


-- sqlcl_snapshot {"hash":"1e37fac5bf93bf315086f24ee49a9c420a1814f7","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_10","schemaName":"AWH_MAIN","sxml":""}