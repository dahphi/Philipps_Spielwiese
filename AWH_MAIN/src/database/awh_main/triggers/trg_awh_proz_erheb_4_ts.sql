create or replace editionable trigger awh_main.trg_awh_proz_erheb_4_ts before
    insert or update on awh_main.awh_proz_erheb_4
    for each row
begin
    select
        sysdate
    into :new.ap4_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_4_ts enable;


-- sqlcl_snapshot {"hash":"ad2c42afe6cdf9347150d973d16ed5ba93e593d5","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_4_TS","schemaName":"AWH_MAIN","sxml":""}