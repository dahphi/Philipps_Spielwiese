create or replace editionable trigger awh_main.trg_awh_infosec_tom_at_ts before
    insert or update on awh_main.awh_infosec_tom_at
    for each row
begin
    select
        sysdate
    into :new.tat_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_tom_at_ts enable;


-- sqlcl_snapshot {"hash":"f1a1812baee191a3617b659689cc9c0b9f769173","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_AT_TS","schemaName":"AWH_MAIN","sxml":""}