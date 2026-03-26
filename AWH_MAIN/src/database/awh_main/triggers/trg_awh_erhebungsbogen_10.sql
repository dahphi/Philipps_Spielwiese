create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_10 after
    delete or update on awh_main.awh_erhebungsbogen_10
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
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEBUNGSBOGEN_10',
               to_char(:old.eb10_lfd_nr),
               to_char(:old.asy_lfd_nr),
               to_char(:old.eb10_export_stand_form),
               :old.eb10_exp_stand_format,
               :old.eb10_exp_stand_zeitraum,
               to_char(:old.eb10_timestamp),
               :old.eb10_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_10 enable;


-- sqlcl_snapshot {"hash":"b49494ad48aa2b62c08dfcbaebd35d0f1b62dd2c","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_10","schemaName":"AWH_MAIN","sxml":""}