create or replace editionable trigger awh_main.trg_awh_infosec_anlagenkat after
    delete or update on awh_main.awh_infosec_anlagenkat
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
    ) values ( 'AWH_INFOSEC_ANLAGENKAT',
               to_char(:old.asy_lfd_nr),
               :old.ank_kat1,
               :old.ank_kat2,
               :old.ank_kat3,
               :old.ank_funk,
               to_char(:old.ank_timestamp),
               :old.ank_user,
               sysdate,
               sys_context('userenv', 'os_user') );

end;
/

alter trigger awh_main.trg_awh_infosec_anlagenkat enable;


-- sqlcl_snapshot {"hash":"c2439d4f423bd3ec9f114cb57d27f923dfbb6234","type":"TRIGGER","name":"TRG_AWH_INFOSEC_ANLAGENKAT","schemaName":"AWH_MAIN","sxml":""}