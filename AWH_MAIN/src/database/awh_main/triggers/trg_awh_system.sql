create or replace editionable trigger awh_main.trg_awh_system after
    delete or update on awh_main.awh_system
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
        log_timestamp,
        log_user
    ) values ( 'AWH_SYSTEM',
               to_char(:old.asy_lfd_nr),
               :old.asy_name,
               :old.asy_funktion,
               :old.asy_abgrenzung,
               to_char(:old.asy_einfuehrung),
               substr(:old.asy_kommentar,
                      1,
                      4000),
               to_char(:old.asy_timestamp),
               :old.asy_user,
               to_char(:old.asy_aktiv),
               :old.asy_aufrufpfad,
               to_char(:old.asy_geloescht),
               :old.asy_startapp,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_system enable;


-- sqlcl_snapshot {"hash":"d2af2fb8b27759ab06997a452afd89ebcf304f11","type":"TRIGGER","name":"TRG_AWH_SYSTEM","schemaName":"AWH_MAIN","sxml":""}