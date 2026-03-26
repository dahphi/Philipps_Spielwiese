create or replace editionable trigger awh_main.trg_awh_erhebungsbogen after
    delete or update on awh_main.awh_erhebungsbogen
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
    ) values ( 'AWH_ERHEBUNGSBOGEN',
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

alter trigger awh_main.trg_awh_erhebungsbogen enable;


-- sqlcl_snapshot {"hash":"9a843da121c9514510189756e3a17dfd0118d21b","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN","schemaName":"AWH_MAIN","sxml":""}