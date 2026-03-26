create or replace editionable trigger awh_main.trg_awh_proz_erheb_2_ts before
    insert or update on awh_main.awh_proz_erheb_2
    for each row
begin
    select
        sysdate
    into :new.ap2_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_2_ts enable;


-- sqlcl_snapshot {"hash":"e2b37221e69f7638741c756159820a4589dcb51c","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_2_TS","schemaName":"AWH_MAIN","sxml":""}