create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_8 after
    delete or update on awh_main.awh_erhebungsbogen_8
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
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEBUNGSBOGEN_8',
               to_char(:old.eb8_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.eb8_persgruppen,
               :old.eb8_berechtigungsrolle,
               :old.eb8_umfangzugriff,
               :old.eb8_artzugriff,
               :old.eb8_zweckzugriff,
               to_char(:old.eb8_timestamp),
               :old.eb8_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_8 enable;


-- sqlcl_snapshot {"hash":"a7575247c0fa402201f6a5ab6e3d3ae5c8b0d51b","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_8","schemaName":"AWH_MAIN","sxml":""}