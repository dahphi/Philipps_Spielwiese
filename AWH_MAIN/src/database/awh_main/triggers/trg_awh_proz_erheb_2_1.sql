create or replace editionable trigger awh_main.trg_awh_proz_erheb_2_1 after
    delete or update on awh_main.awh_proz_erheb_2_1
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
    ) values ( 'AWH_PROZ_ERHEB_2_1',
               to_char(:old.ap21_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.per_lfd_nr_verant_ap),
               to_char(:old.per_lfd_nr_verant_fk),
               to_char(:old.ap21_timestamp),
               :old.ap21_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_2_1 enable;


-- sqlcl_snapshot {"hash":"ef1009a873a90a845727143ac6552b02640d74e3","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_2_1","schemaName":"AWH_MAIN","sxml":""}