create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_1 after
    delete or update on awh_main.awh_erhebungsbogen_1
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
    ) values ( 'AWH_ERHEBUNGSBOGEN_1',
               to_char(:old.eb1_lfd_nr),
               :old.eb1_verarb_persdata,
               :old.eb1_name_anschrift,
               :old.link_zum_anhang,
               to_char(:old.eb1_timestamp),
               :old.eb1_user,
               to_char(:old.asy_lfd_nr),
               to_char(:old.eb1_inakt_persdata),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_1 enable;


-- sqlcl_snapshot {"hash":"8c4b6571b81082c65a9dcb669f2239184ac3a486","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_1","schemaName":"AWH_MAIN","sxml":""}