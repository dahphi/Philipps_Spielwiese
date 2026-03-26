create or replace editionable trigger awh_main.trg_awh_infosec_comp after
    delete or update on awh_main.awh_infosec_comp
    for each row
begin
    insert into awh_log (
        log_table,
        log_col1_val,
        log_col2_val,
        log_col3_val,
        log_col4_val,
        log_col5_val,
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_COMP',
               to_char(:old.asy_lfd_nr),
               to_char(:old.cop_dsgvo),
               to_char(:old.cop_betrvg),
               to_char(:old.cop_kritisv),
               :old.cop_elem_infra,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_comp enable;


-- sqlcl_snapshot {"hash":"1eb4429e079c2363f4dabeebd69e2f9c7d4028b8","type":"TRIGGER","name":"TRG_AWH_INFOSEC_COMP","schemaName":"AWH_MAIN","sxml":""}