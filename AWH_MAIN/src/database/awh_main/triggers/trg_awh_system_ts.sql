create or replace editionable trigger awh_main.trg_awh_system_ts before
    insert or update on awh_main.awh_system
    for each row
begin
    select
        sysdate
    into :new.asy_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_system_ts enable;


-- sqlcl_snapshot {"hash":"8962bcfc0da16f2f24a3398093c20b01b7c36c44","type":"TRIGGER","name":"TRG_AWH_SYSTEM_TS","schemaName":"AWH_MAIN","sxml":""}