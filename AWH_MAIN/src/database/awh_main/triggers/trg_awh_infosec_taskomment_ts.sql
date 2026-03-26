create or replace editionable trigger awh_main.trg_awh_infosec_taskomment_ts before
    insert or update on awh_main.awh_infosec_taskomment
    for each row
begin
    select
        sysdate
    into :new.tsk_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_taskomment_ts enable;


-- sqlcl_snapshot {"hash":"aafc029121c0846520e3c75849ae50c44101df13","type":"TRIGGER","name":"TRG_AWH_INFOSEC_TASKOMMENT_TS","schemaName":"AWH_MAIN","sxml":""}