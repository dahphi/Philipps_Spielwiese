create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_9_ts before
    insert or update on awh_main.awh_erhebungsbogen_9
    for each row
begin
    select
        sysdate
    into :new.eb9_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_9_ts enable;


-- sqlcl_snapshot {"hash":"b657b097e202b93c4784fc50a09e8fc00673277b","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_9_TS","schemaName":"AWH_MAIN","sxml":""}