create or replace editionable trigger awh_main.trg_awh_infosec_tom_handbuch_ts before
    insert or update on awh_main.awh_infosec_tom_handbuch
    for each row
begin
    select
        sysdate
    into :new.hnb_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_tom_handbuch_ts enable;


-- sqlcl_snapshot {"hash":"383b0077b1f49e0cc0881820cfef4344dabbd7fe","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_HANDBUCH_TS","schemaName":"AWH_MAIN","sxml":""}