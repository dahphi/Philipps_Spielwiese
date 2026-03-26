create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_5_ts before
    insert or update on awh_main.awh_erhebungsbogen_5
    for each row
begin
    select
        sysdate
    into :new.eb5_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_5_ts enable;


-- sqlcl_snapshot {"hash":"fcf44abdf8412932d5e13656bf41423c1c0659e6","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_5_TS","schemaName":"AWH_MAIN","sxml":""}