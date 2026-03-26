create or replace editionable trigger awh_main.trg_awh_infosec_geschaeftskritisch after
    delete or update on awh_main.awh_infosec_geschaeftskritisch
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_GESCHAEFTSKRITISCH',
               to_char(:old.asy_lfd_nr),
               to_char(:old.gek_lfd_nr),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_geschaeftskritisch enable;


-- sqlcl_snapshot {"hash":"e5ae6435cc1ec4743c4a90b0a6e08e1547cbb420","type":"TRIGGER","name":"TRG_AWH_INFOSEC_GESCHAEFTSKRITISCH","schemaName":"AWH_MAIN","sxml":""}