create or replace editionable trigger awh_main.trg_awh_infosec_tom_vf after
    delete or update on awh_main.awh_infosec_tom_vf
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
    ) values ( 'AWH_INFOSEC_TOM_VF',
               to_char(:old.asy_lfd_nr),
               to_char(:old.zet_lfd_nr),
               to_char(:old.ueb_lfd_nr),
               to_char(:old.asf_lfd_nr),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_tom_vf enable;


-- sqlcl_snapshot {"hash":"e20788780148e3a21420ec86a8d0f02694841594","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_VF","schemaName":"AWH_MAIN","sxml":""}