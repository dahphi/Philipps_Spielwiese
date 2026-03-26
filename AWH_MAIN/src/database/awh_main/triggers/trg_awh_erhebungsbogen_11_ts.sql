create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_11_ts before
    insert or update on awh_main.awh_erhebungsbogen_11
    for each row
begin
    select
        sysdate
    into :new.eb11_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_11_ts enable;


-- sqlcl_snapshot {"hash":"0f01393fc510cb28173684dd5b7ad6e704f2f270","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_11_TS","schemaName":"AWH_MAIN","sxml":""}