create or replace editionable trigger awh_main.trg_awh_proz_erheb_2 after
    delete or update on awh_main.awh_proz_erheb_2
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
        log_col9_val,
        log_col10_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_PROZ_ERHEB_2',
               to_char(:old.ap2_lfd_nr),
               to_char(:old.pro_lfd_nr),
               :old.ap2_verarb_taet,
               :old.ap2_proz_ebene,
               to_char(:old.ap2_dat_einf),
               :old.ap2_ueber_gp,
               to_char(:old.per_lfd_nr_verant_ap),
               to_char(:old.per_lfd_nr_verant_fuehr),
               to_char(:old.ap2_timestamp),
               :old.ap2_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_2 enable;


-- sqlcl_snapshot {"hash":"f6debe2ba244dc5d857b4fc6de413af4ec545f4a","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_2","schemaName":"AWH_MAIN","sxml":""}