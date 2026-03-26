create or replace editionable trigger awh_main.trg_awh_proz_freigaben after
    delete or update on awh_main.awh_proz_freigaben
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
    ) values ( 'AWH_PROZ_ERHEB_11',
               to_char(:old.ap11_lfd_nr),
               to_char(:old.pro_lfd_nr),
               to_char(:old.ap11_f_ver_ap),
               to_char(:old.ap11_f_ver_fk),
               to_char(:old.ap11_f_mv_ap),
               to_char(:old.ap11_f_mv_fk),
               to_char(:old.ap11_f_bl_technik),
               to_char(:old.ap11_f_rr),
               to_char(:old.ap11_f_dsb),
               to_char(:old.ap11_f_gf),
               to_char(:old.ap11_timestamp),
               :old.ap11_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_proz_freigaben enable;


-- sqlcl_snapshot {"hash":"8b6917bdfe65bc5e89a8dc41049c4e74757268d2","type":"TRIGGER","name":"TRG_AWH_PROZ_FREIGABEN","schemaName":"AWH_MAIN","sxml":""}