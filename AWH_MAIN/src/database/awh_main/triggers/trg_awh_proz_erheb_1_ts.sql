create or replace editionable trigger awh_main.trg_awh_proz_erheb_1_ts before
    insert or update on awh_main.awh_proz_erheb_1
    for each row
begin
    select
        sysdate
    into :new.ap1_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_1_ts enable;


-- sqlcl_snapshot {"hash":"9cd08a2f78cf99135e2f6999ed3d0ae9ee80ecdf","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_1_TS","schemaName":"AWH_MAIN","sxml":""}