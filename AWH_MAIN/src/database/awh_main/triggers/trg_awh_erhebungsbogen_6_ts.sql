create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_6_ts before
    insert or update on awh_main.awh_erhebungsbogen_6
    for each row
begin
    select
        sysdate
    into :new.eb6_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_6_ts enable;


-- sqlcl_snapshot {"hash":"5cd873d00f564d83a11acdfc83489ff6bbf62d61","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_6_TS","schemaName":"AWH_MAIN","sxml":""}