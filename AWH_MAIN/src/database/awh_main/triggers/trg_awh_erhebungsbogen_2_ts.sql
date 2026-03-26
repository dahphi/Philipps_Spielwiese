create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_2_ts before
    insert or update on awh_main.awh_erhebungsbogen_2
    for each row
begin
    select
        sysdate
    into :new.eb2_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_2_ts enable;


-- sqlcl_snapshot {"hash":"1c5dea9a885fa763bdb080e068d3f050c461b956","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_2_TS","schemaName":"AWH_MAIN","sxml":""}