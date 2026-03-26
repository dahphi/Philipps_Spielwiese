create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_2 after
    delete or update on awh_main.awh_erhebungsbogen_2
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
        log_col11_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEBUNGSBOGEN_2',
               to_char(:old.eb2_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.eb2_zweck_persdaten,
               :old.eb2_spezialgesetz_regel,
               :old.eb2_einwilligung,
               :old.eb2_kollektivvereinbarung,
               :old.eb2_beschaeftigung,
               :old.eb2_vertragsanbahnung,
               :old.eb2_interessenabwaegung,
               to_char(:old.eb2_timestamp),
               :old.eb2_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_2 enable;


-- sqlcl_snapshot {"hash":"b8e3730a02389a7fef5af6a3496dc739708d126d","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_2","schemaName":"AWH_MAIN","sxml":""}