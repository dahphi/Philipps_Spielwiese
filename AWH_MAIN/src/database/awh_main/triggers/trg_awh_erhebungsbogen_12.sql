create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_12 after
    delete or update on awh_main.awh_erhebungsbogen_12
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
    ) values ( 'AWH_ERHEBUNGSBOGEN_12',
               to_char(:old.eb12_lfd_nr),
               to_char(:old.asy_lfd_nr),
               to_char(:old.eb12_voreinstellungen_auto),
               :old.eb12_ve_auto_erlaeuterung,
               to_char(:old.eb12_timestamp),
               :old.eb12_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_12 enable;


-- sqlcl_snapshot {"hash":"0afb25867191d2195d8998b4b2d1dad2ae0f103c","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_12","schemaName":"AWH_MAIN","sxml":""}