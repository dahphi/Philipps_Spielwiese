create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_9_dfa after
    delete or update on awh_main.awh_erhebungsbogen_9_dfa
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
    ) values ( 'AWH_ERHEBUNGSBOGEN_9_DFA',
               to_char(:old.e9d_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.e9d_link_schw_dfa,
               :old.e9d_link_dfa,
               :old.e9d_schw,
               to_char(:old.e9d_timestamp),
               :old.e9d_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_9_dfa enable;


-- sqlcl_snapshot {"hash":"e919b7f3633285ed70902999182d88849f91000f","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_9_DFA","schemaName":"AWH_MAIN","sxml":""}