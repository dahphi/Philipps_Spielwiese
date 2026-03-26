create or replace editionable trigger awh_main.trg_awh_proz_erheb_3 after
    delete or update on awh_main.awh_proz_erheb_3
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
        log_timestamp,
        log_user
    ) values ( 'AWH_PROZ_ERHEB_3',
               to_char(:old.ap3_lfd_nr),
               to_char(:old.pro_lfd_nr),
               :old.ap3_zweckbestimmung,
               to_char(:old.ap3_vertrag_erbringung),
               to_char(:old.ap3_besch_verh),
               to_char(:old.ap3_einkaufsvertrag),
               to_char(:old.ap3_beratervertrag),
               :old.ap3_sonstiges,
               :old.ap3_verarb_vorvertrag_mass,
               :old.ap3_verarb_recht_ver,
               :old.ap3_verarb_wahrn_auf,
               :old.ap3_verarb_berech_int,
               :old.ap3_einwill_verarb,
               to_char(:old.ap3_einwill_nachweise),
               :old.ap3_sonstige,
               to_char(:old.ap3_timestamp),
               :old.ap3_user,
               to_char(:old.ap3_risiko),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_erheb_3 enable;


-- sqlcl_snapshot {"hash":"ab079ef16a5fd2ff557633b109d0931fca044cec","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_3","schemaName":"AWH_MAIN","sxml":""}