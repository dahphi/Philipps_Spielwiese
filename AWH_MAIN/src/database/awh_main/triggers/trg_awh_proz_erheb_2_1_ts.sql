create or replace editionable trigger awh_main.trg_awh_proz_erheb_2_1_ts before
    insert or update on awh_main.awh_proz_erheb_2_1
    for each row
begin
    select
        sysdate
    into :new.ap21_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_2_1_ts enable;


-- sqlcl_snapshot {"hash":"8b057f969ff5f961f62c8b2d941911a826ec4296","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_2_1_TS","schemaName":"AWH_MAIN","sxml":""}