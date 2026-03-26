create or replace editionable trigger awh_main.trg_awh_infosec_sysverbindung after
    delete or update on awh_main.awh_infosec_sysverbindung
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
    ) values ( 'AWH_INFOSEC_SYSVERBINDUNG',
               to_char(:old.asy_lfd_nr_out),
               to_char(:old.asy_lfd_nr_in),
               to_char(:old.trv_lfd_nr),
               to_char(:old.vet_lfd_nr),
               to_char(:old.int_lfd_nr),
               to_char(:old.vef_lfd_nr),
               to_char(:old.aut_lfd_nr),
               :old.svb_erlauterung,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_sysverbindung enable;


-- sqlcl_snapshot {"hash":"15145a6cbbb8588fc1cfd7ea6fbca7a9f9d4a4bd","type":"TRIGGER","name":"TRG_AWH_INFOSEC_SYSVERBINDUNG","schemaName":"AWH_MAIN","sxml":""}