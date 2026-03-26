create or replace editionable trigger awh_main.trg_awh_eudsgvo_befuell after
    delete or update on awh_main.awh_eudsgvo_befuell
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_col3_val,
        log_col4_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_EUDSGVO_BEFUELL',
               to_char(:old.bef_lfd_nr),
               to_char(:old.beg_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.bef_kommentar,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_eudsgvo_befuell enable;


-- sqlcl_snapshot {"hash":"213a855b826277f19d39d7ebdd984606187a9492","type":"TRIGGER","name":"TRG_AWH_EUDSGVO_BEFUELL","schemaName":"AWH_MAIN","sxml":""}