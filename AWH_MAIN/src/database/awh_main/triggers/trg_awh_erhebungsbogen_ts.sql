create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_ts before
    insert or update on awh_main.awh_erhebungsbogen
    for each row
begin
    select
        sysdate
    into :new.erh_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_ts enable;


-- sqlcl_snapshot {"hash":"e5d5b47979f8ddd5b128740ab0895c3ecd03b4a2","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_TS","schemaName":"AWH_MAIN","sxml":""}