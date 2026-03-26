create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_10_ts before
    insert or update on awh_main.awh_erhebungsbogen_10
    for each row
begin
    select
        sysdate
    into :new.eb10_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_10_ts enable;


-- sqlcl_snapshot {"hash":"e6f2cc66dbf68e40556a7281f34496e81b304331","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_10_TS","schemaName":"AWH_MAIN","sxml":""}