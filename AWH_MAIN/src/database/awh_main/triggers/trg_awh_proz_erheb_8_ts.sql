create or replace editionable trigger awh_main.trg_awh_proz_erheb_8_ts before
    insert or update on awh_main.awh_proz_erheb_8
    for each row
begin
    select
        sysdate
    into :new.ap8_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_8_ts enable;


-- sqlcl_snapshot {"hash":"fbd87d25384013996e44c56afd798d81675b0ebb","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_8_TS","schemaName":"AWH_MAIN","sxml":""}