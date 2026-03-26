create or replace editionable trigger awh_main.trg_awh_infosec_zul_nutz after
    delete or update on awh_main.awh_infosec_zul_nutzung
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
        log_timestamp,
        log_user
    ) values ( 'AWH_INFOSEC_ZUL_NUTZUNG',
               to_char(:old.asy_lfd_nr),
               to_char(:old.zdf_lfd_nr),
               to_char(:old.zul_referenz_regel),
               to_char(:old.zul_kennzeichnung),
               to_char(:old.zul_timestamp),
               :old.zul_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_zul_nutz enable;


-- sqlcl_snapshot {"hash":"1cbfb3d171ea7463d74c43d592a36608c663b5c4","type":"TRIGGER","name":"TRG_AWH_INFOSEC_ZUL_NUTZ","schemaName":"AWH_MAIN","sxml":""}