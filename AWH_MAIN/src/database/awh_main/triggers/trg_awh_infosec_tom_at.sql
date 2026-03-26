create or replace editionable trigger awh_main.trg_awh_infosec_tom_at after
    delete or update on awh_main.awh_infosec_tom_at
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_TOM_AT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.mfa_lfd_nr),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_tom_at enable;


-- sqlcl_snapshot {"hash":"5313ec98815cdd933db2b9c701365628ba581894","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_AT","schemaName":"AWH_MAIN","sxml":""}