create or replace editionable trigger awh_main.trg_awh_erheb_1_fachbereich after
    delete or update on awh_main.awh_erheb_1_fachbereich
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
        log_timestamp,
        log_user
    ) values ( 'AWH_ERHEB_1_FACHBEREICH',
               to_char(:old.erf_lfd_nr),
               to_char(:old.asy_lfd_nr),
               to_char(:old.vet_lfd_nr),
               to_char(:old.per_lfd_nr),
               to_char(:old.buu_lfd_nr),
               to_char(:old.erf_timestamp),
               :old.erf_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erheb_1_fachbereich enable;


-- sqlcl_snapshot {"hash":"15c13f52691fa74e69e0c5adb72bdda0b05b7bf9","type":"TRIGGER","name":"TRG_AWH_ERHEB_1_FACHBEREICH","schemaName":"AWH_MAIN","sxml":""}