create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_5 after
    delete or update on awh_main.awh_erhebungsbogen_5
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
        log_col12_val,
        log_col13_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEBUNGSBOGEN_5',
               to_char(:old.eb5_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.eb5_internestelle_dwi,
               :old.eb5_artdaten_dwi,
               :old.eb5_zweck_dwi,
               :old.eb5_externestelle_dwe,
               :old.eb5_artdaten_dwe,
               :old.eb5_zweck_dwe,
               :old.eb5_staat_dws,
               :old.eb5_artdaten_dws,
               :old.eb5_zweck_dws,
               to_char(:old.eb5_timestamp),
               :old.eb5_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_5 enable;


-- sqlcl_snapshot {"hash":"a42fa0b297d23dd05845c38dffaa1d09a9157afb","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_5","schemaName":"AWH_MAIN","sxml":""}