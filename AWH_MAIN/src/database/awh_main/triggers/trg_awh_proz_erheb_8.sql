create or replace editionable trigger awh_main.trg_awh_proz_erheb_8 after
    delete or update on awh_main.awh_proz_erheb_8
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
    ) values ( 'AWH_PROZ_ERHEB_8',
               to_char(:old.ap8_lfd_nr),
               to_char(:old.pro_lfd_nr),
               :old.ap8_aufbewahrung,
               to_char(:old.ap8_lf_95),
               to_char(:old.ap8_lf_loeschkon),
               :old.ap8_lf_sonst,
               to_char(:old.ap8_timestamp),
               :old.ap8_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_8 enable;


-- sqlcl_snapshot {"hash":"93ed47ed4c1359ef22cbdd049b43263dd5309c8f","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_8","schemaName":"AWH_MAIN","sxml":""}