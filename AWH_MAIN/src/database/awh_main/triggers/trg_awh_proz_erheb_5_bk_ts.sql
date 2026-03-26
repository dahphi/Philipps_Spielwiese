create or replace editionable trigger awh_main.trg_awh_proz_erheb_5_bk_ts before
    insert or update on awh_main.awh_proz_erheb_5_bes_kat
    for each row
begin
    select
        sysdate
    into :new.ap5bk_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_erheb_5_bk_ts enable;


-- sqlcl_snapshot {"hash":"5b7bc407052eb895b1842742f601f37cfb8cb0ba","type":"TRIGGER","name":"TRG_AWH_PROZ_ERHEB_5_BK_TS","schemaName":"AWH_MAIN","sxml":""}