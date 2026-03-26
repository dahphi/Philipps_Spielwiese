create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_1_ts before
    insert or update on awh_main.awh_erhebungsbogen_1
    for each row
begin
    select
        sysdate
    into :new.eb1_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_1_ts enable;


-- sqlcl_snapshot {"hash":"e8c5857da7d1956f80e5c00d2f55ab8ff4e56080","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_1_TS","schemaName":"AWH_MAIN","sxml":""}