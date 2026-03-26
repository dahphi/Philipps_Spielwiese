create or replace editionable trigger awh_main.trg_awh_proz_erheb_5_ts before
    insert or update on awh_main.awh_proz_erheb_5
    for each row
begin
    select
        sysdate
    into :new.ap5_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_5_ts enable;


-- sqlcl_snapshot {"hash":"f270a4cc1fc558e08588205d59674bc067f1ceea","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_5_TS","schemaName":"AWH_MAIN","sxml":""}