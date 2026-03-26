create or replace editionable trigger awh_main.trg_awh_proz_erheb_3_ts before
    insert or update on awh_main.awh_proz_erheb_3
    for each row
begin
    select
        sysdate
    into :new.ap3_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_3_ts enable;


-- sqlcl_snapshot {"hash":"d591acdb22dbfc87708f0de03a0e299816d06330","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_3_TS","schemaName":"AWH_MAIN","sxml":""}