create or replace editionable trigger awh_main.trg_awh_infosec_tom_vt_ts before
    insert or update on awh_main.awh_infosec_tom_vt
    for each row
begin
    select
        sysdate
    into :new.tvt_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_tom_vt_ts enable;


-- sqlcl_snapshot {"hash":"603cef8dd6a574e89e91c70f4315bf103053b735","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TOM_VT_TS","schemaName":"AWH_MAIN","sxml":""}