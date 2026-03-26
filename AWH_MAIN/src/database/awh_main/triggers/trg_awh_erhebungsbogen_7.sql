create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_7 after
    delete or update on awh_main.awh_erhebungsbogen_7
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
    ) values ( 'AWH_ERHEBUNGSBOGEN_7',
               to_char(:old.eb7_lfd_nr),
               to_char(:old.asy_lfd_nr),
               :old.eb7_hersteller,
               :old.eb7_backend,
               :old.eb7_schnittstellen,
               null,
               to_char(:old.eb7_timestamp),
               :old.eb7_user,
               :old.eb7_herkunftsland,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_7 enable;


-- sqlcl_snapshot {"hash":"fe4dc048ba37e8a4c85752ae205d20349f5ca2cf","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_7","schemaName":"AWH_MAIN","sxml":""}