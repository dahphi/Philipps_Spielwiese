create or replace editionable trigger awh_main.trg_awh_infosec_tom_vt after
    delete or update on awh_main.awh_infosec_tom_vt
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
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_TOM_VT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.trv_lfd_nr),
               to_char(:old.sov_lfd_nr),
               :old.tvt_zugsteu,
               to_char(:old.tvt_berechtko),
               to_char(:old.tvt_rollen),
               to_char(:old.tvt_einerolle),
               to_char(:old.tvt_zugverw),
               to_char(:old.ere_lfd_nr),
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_tom_vt enable;


-- sqlcl_snapshot {"hash":"d3ecd222ddbbbd534d1a525f411192bbe1603108","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_VT","schemaName":"AWH_MAIN","sxml":""}