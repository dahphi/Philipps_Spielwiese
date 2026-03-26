create or replace editionable trigger awh_main.trg_awh_infosec_sbkomment_ts before
    insert or update on awh_main.awh_infosec_sbkomment
    for each row
begin
    select
        sysdate
    into :new.sbk_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_sbkomment_ts enable;


-- sqlcl_snapshot {"hash":"fa96a3b663ec129322d02188ec61f8f341de5882","type":"TRIGGER","name":"TRG_AWH_INFOSEC_SBKOMMENT_TS","schemaName":"AWH_MAIN","sxml":""}