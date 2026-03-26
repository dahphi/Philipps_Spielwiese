create or replace editionable trigger awh_main.trg_awh_proz_erheb_1 after
    delete or update on awh_main.awh_proz_erheb_1
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
    ) values ( 'AWH_PROZ_ERHEB_1',
               to_char(:old.ap1_lfd_nr),
               :old.ap1_verant_stelle,
               to_char(:old.per_lfd_nr_ges_ver),
               to_char(:old.per_lfd_nr_vertr),
               to_char(:old.per_lfd_nr_ds),
               to_char(:old.pro_lfd_nr),
               to_char(:old.ap1_timestamp),
               :old.ap1_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_1 enable;


-- sqlcl_snapshot {"hash":"a5d41f849673dd7d2cef330bb35978528d8f1a04","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_1","schemaName":"AWH_MAIN","sxml":""}