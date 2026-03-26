create or replace editionable trigger awh_main.trg_awh_infosec_anlagenkat_ts before
    insert or update on awh_main.awh_infosec_anlagenkat
    for each row
begin
    select
        sysdate
    into :new.ank_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_anlagenkat_ts enable;


-- sqlcl_snapshot {"hash":"cb2e9854028f51cef6d247e7ec1719aa76ac7b86","type":"TRIGGER","name":"TRG_AWH_INFOSEC_ANLAGENKAT_TS","schemaName":"AWH_MAIN","sxml":""}