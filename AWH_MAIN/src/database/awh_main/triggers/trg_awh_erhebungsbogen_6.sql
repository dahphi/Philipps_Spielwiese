create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_6 after
    update or delete on awh_main.awh_erhebungsbogen_6
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
    ) values ( 'AWH_ERHEBUNGSBOGEN_6',
               to_char(:old.eb6_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.eb6_aufbewloeschfrist,
               :old.eb6_loeschregeln,
               to_char(:old.eb6_timestamp),
               :old.eb6_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_6 enable;


-- sqlcl_snapshot {"hash":"ee8bd211454d8a526a7d7194a700ec6a45f6a653","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_6","schemaName":"AWH_MAIN","sxml":""}