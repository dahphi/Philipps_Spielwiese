create or replace editionable trigger awh_main.trg_awh_proz_erheb_10_ts before
    insert or update on awh_main.awh_proz_erheb_10
    for each row
begin
    select
        sysdate
    into :new.ap10_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_10_ts enable;


-- sqlcl_snapshot {"hash":"5350ff3faba148b6ad6567aceb285b7b28190997","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_10_TS","schemaName":"AWH_MAIN","sxml":""}