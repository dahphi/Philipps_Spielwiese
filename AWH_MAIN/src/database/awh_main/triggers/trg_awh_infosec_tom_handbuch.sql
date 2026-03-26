create or replace editionable trigger awh_main.trg_awh_infosec_tom_handbuch after
    delete or update on awh_main.awh_infosec_tom_handbuch
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
    ) values ( 'AWH_INFOSEC_TOM_HANDBUCH',
               to_char(:old.asy_lfd_nr),
               :old.hnb_patch_chng,
               :old.hnb_zugangsverw,
               :old.hnb_wiederanlauf,
               :old.hnb_buch1,
               :old.hnb_buch2,
               :old.hnb_buch3,
               :old.hnb_buch4,
               :old.hnb_buch5,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_tom_handbuch enable;


-- sqlcl_snapshot {"hash":"a66cffc87aabd1ff460802e972fb0afa74f16a1c","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_HANDBUCH","schemaName":"AWH_MAIN","sxml":""}