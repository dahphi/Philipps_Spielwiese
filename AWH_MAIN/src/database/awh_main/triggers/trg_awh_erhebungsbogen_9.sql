create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_9 after
    delete or update on awh_main.awh_erhebungsbogen_9
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
        log_col14_val,
        log_col15_val,
        log_col16_val,
        log_col17_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEBUNGSBOGEN_9',
               to_char(:old.eb9_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.eb9_ds_itsicherheit_grund,
               to_char(:old.eb9_risikoanalyse_erfolgt),
               to_char(:old.eb9_massnahmen_sicherheitskonz),
               :old.eb9_anonym_pseudonym,
               null,
               :old.eb9_backup,
               :old.eb9_redundantedaten,
               null,
               null,
               null,
               :old.eb9_schutzderrechte,
               :old.eb9_protokollierung,
               :old.eb9_pruefung_abstaende,
               to_char(:old.eb9_timestamp),
               :old.eb9_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_9 enable;


-- sqlcl_snapshot {"hash":"7674b2ca034fd1f6bf24e4112a4d9d34fcd221b6","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_9","schemaName":"AWH_MAIN","sxml":""}