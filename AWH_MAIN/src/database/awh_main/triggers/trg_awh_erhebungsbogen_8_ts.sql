create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_8_ts before
    insert or update on awh_main.awh_erhebungsbogen_8
    for each row
begin
    select
        sysdate
    into :new.eb8_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_8_ts enable;


-- sqlcl_snapshot {"hash":"a1bcdc55118bd6da689f10b51eecb06002a26e77","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_8_TS","schemaName":"AWH_MAIN","sxml":""}