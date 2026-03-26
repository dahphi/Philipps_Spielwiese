create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_12_ts before
    insert or update on awh_main.awh_erhebungsbogen_12
    for each row
begin
    select
        sysdate
    into :new.eb12_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_12_ts enable;


-- sqlcl_snapshot {"hash":"c0b13646b6e74c2554f8b1be38baf0bb952b6b3f","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_12_TS","schemaName":"AWH_MAIN","sxml":""}