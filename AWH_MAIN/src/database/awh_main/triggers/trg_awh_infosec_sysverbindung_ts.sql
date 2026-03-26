create or replace editionable trigger awh_main.trg_awh_infosec_sysverbindung_ts before
    insert or update on awh_main.awh_infosec_sysverbindung
    for each row
begin
    select
        sysdate
    into :new.svb_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_sysverbindung_ts enable;


-- sqlcl_snapshot {"hash":"aa7e3836d2bea0c2d86bfcf37416c60bd815bd37","type":"TRIGGER","name":"TRG_AWH_INFOSEC_SYSVERBINDUNG_TS","schemaName":"AWH_MAIN","sxml":""}