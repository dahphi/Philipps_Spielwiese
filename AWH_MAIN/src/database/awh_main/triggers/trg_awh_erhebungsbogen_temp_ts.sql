create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_temp_ts before
    insert or update on awh_main.awh_erhebungsbogen_temp
    for each row
begin
    select
        sysdate
    into :new.erh_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_temp_ts enable;


-- sqlcl_snapshot {"hash":"e548d3d228d22b3bcd6c2ed526c7b716f24680cd","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_TEMP_TS","schemaName":"AWH_MAIN","sxml":""}