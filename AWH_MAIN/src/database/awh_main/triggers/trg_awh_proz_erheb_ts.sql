create or replace editionable trigger awh_main.trg_awh_proz_erheb_ts before
    insert or update on awh_main.awh_proz_erheb
    for each row
begin
    select
        sysdate
    into :new.ape_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_ts enable;


-- sqlcl_snapshot {"hash":"4c96e57caa10e7ae5bedd0e313163fc858c5d8d6","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_TS","schemaName":"AWH_MAIN","sxml":""}