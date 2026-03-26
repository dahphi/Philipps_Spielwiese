create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_11 after
    delete or update on awh_main.awh_erhebungsbogen_11
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
        log_col18_val,
        log_col19_val,
        log_col20_val,
        log_col21_val,
        log_col22_val,
        log_col23_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEBUNGSBOGEN_11',
               to_char(:old.eb11_lfd_nr),
               to_char(:old.asy_lfd_nr),
               substr(:old.eb11_satz_pers_daten,
                      1,
                      4000),
               :old.eb11_nakodv_form,
               :old.eb11_nakodv_zeitpunkt,
               :old.eb11_kodsb_form,
               :old.eb11_kodsb_zeitpunkt,
               :old.eb11_zweckrecht_form,
               :old.eb11_zweckrecht_zeitpunkt,
               :old.eb11_empfkat_form,
               :old.eb11_empfkat_zeitpunkt,
               :old.eb11_dauerpers_form,
               :old.eb11_dauerpers_zeitpunkt,
               :old.eb11_widerspruch_form,
               :old.eb11_widerspruch_zeitpunkt,
               :old.eb11_einrueck_form,
               :old.eb11_einrueck_zeitpunkt,
               :old.eb11_beschrecht_form,
               :old.eb11_beschrecht_zeitpunkt,
               :old.eb11_infobereit_form,
               :old.eb11_infobereit_zeitpunkt,
               to_char(:old.eb11_timestamp),
               :old.eb11_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_11 enable;


-- sqlcl_snapshot {"hash":"52d64daa3bd71073aaf7e63c368087bfa282b1d2","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_11","schemaName":"AWH_MAIN","sxml":""}