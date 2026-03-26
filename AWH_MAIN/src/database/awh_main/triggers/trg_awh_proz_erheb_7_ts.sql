create or replace editionable trigger awh_main.trg_awh_proz_erheb_7_ts before
    insert or update on awh_main.awh_proz_erheb_7
    for each row
begin
    select
        sysdate
    into :new.ap7_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_7_ts enable;


-- sqlcl_snapshot {"hash":"90a9460b61830217f9f420b04832ab473ab0ef64","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_7_TS","schemaName":"AWH_MAIN","sxml":""}