create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_3_ts before
    insert or update on awh_main.awh_erhebungsbogen_3
    for each row
begin
    select
        sysdate
    into :new.eb3_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_3_ts enable;


-- sqlcl_snapshot {"hash":"0626e29265713337fc528114e7bc0b28739a138d","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_3_TS","schemaName":"AWH_MAIN","sxml":""}