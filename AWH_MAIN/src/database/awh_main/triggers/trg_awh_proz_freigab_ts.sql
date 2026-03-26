create or replace editionable trigger awh_main.trg_awh_proz_freigab_ts before
    insert or update on awh_main.awh_proz_freigaben
    for each row
begin
    select
        sysdate
    into :new.ap11_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_proz_freigab_ts enable;


-- sqlcl_snapshot {"hash":"91e3d04f4564a136645546a444fcd669b2f83b61","type":"TRIGGER","name":"TRG_AWH_PROZ_FREIGAB_TS","schemaName":"AWH_MAIN","sxml":""}