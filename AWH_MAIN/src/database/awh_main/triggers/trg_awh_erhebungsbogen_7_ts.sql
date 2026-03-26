create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_7_ts before
    insert or update on awh_main.awh_erhebungsbogen_7
    for each row
begin
    select
        sysdate
    into :new.eb7_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_7_ts enable;


-- sqlcl_snapshot {"hash":"82cf96977c8b40903c115a5c0df58e268fc3b78e","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_7_TS","schemaName":"AWH_MAIN","sxml":""}