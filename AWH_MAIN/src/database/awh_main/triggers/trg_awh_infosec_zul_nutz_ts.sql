create or replace editionable trigger awh_main.trg_awh_infosec_zul_nutz_ts before
    insert or update on awh_main.awh_infosec_zul_nutzung
    for each row
begin
    select
        sysdate
    into :new.zul_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_zul_nutz_ts enable;


-- sqlcl_snapshot {"hash":"af47976f7dd5fcaa66ba7f1251d413e548cf5886","type":"TRIGGER","name":"TRG_AWH_INFOSEC_ZUL_NUTZ_TS","schemaName":"AWH_MAIN","sxml":""}