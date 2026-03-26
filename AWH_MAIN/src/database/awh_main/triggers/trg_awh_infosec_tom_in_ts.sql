create or replace editionable trigger awh_main.trg_awh_infosec_tom_in_ts before
    insert or update on awh_main.awh_infosec_tom_in
    for each row
begin
    select
        sysdate
    into :new.tin_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_tom_in_ts enable;


-- sqlcl_snapshot {"hash":"9134d5f8ae5c968ddd579421ccf27a0a578cf4fd","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_IN_TS","schemaName":"AWH_MAIN","sxml":""}