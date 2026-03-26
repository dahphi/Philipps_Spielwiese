create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_temp after
    delete or update on awh_main.awh_erhebungsbogen_temp
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
    ) values ( 'AWH_ERHEBUNGSBOGEN_TEMP',
               to_char(:old.erh_lfd_nr),
               to_char(:old.asy_lfd_nr),
               to_char(:old.per_lfd_nr_ausf_per),
               to_char(:old.erh_datum),
               to_char(:old.erh_timestamp),
               :old.erh_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_temp enable;


-- sqlcl_snapshot {"hash":"01741f2eb6497058bbb6fb9151172c7da732b5da","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_TEMP","schemaName":"AWH_MAIN","sxml":""}