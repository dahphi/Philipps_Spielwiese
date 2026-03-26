create or replace editionable trigger awh_main.trg_awh_infosec_tom_vf_ts before
    insert or update on awh_main.awh_infosec_tom_vf
    for each row
begin
    select
        sysdate
    into :new.tvf_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_tom_vf_ts enable;


-- sqlcl_snapshot {"hash":"e147c87ccc5fe2a7a55313a66423569e8bd536c0","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_VF_TS","schemaName":"AWH_MAIN","sxml":""}