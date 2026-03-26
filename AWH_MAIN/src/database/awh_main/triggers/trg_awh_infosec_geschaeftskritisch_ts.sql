create or replace editionable trigger awh_main.trg_awh_infosec_geschaeftskritisch_ts before
    insert or update on awh_main.awh_infosec_geschaeftskritisch
    for each row
begin
    select
        sysdate
    into :new.gks_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_geschaeftskritisch_ts enable;


-- sqlcl_snapshot {"hash":"30bd72a2f22df7af6043499da75acf49456afc94","type":"TRIGGER","name":"TRG_AWH_INFOSEC_GESCHAEFTSKRITISCH_TS","schemaName":"AWH_MAIN","sxml":""}