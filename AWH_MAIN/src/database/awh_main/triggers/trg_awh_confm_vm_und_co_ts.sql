create or replace editionable trigger awh_main.trg_awh_confm_vm_und_co_ts before
    insert or update on awh_main.awh_confm_vm_und_co
    for each row
begin
    select
        sysdate
    into :new.vvg_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_confm_vm_und_co_ts enable;


-- sqlcl_snapshot {"hash":"89c546338805a052e7040f8f9a925a268c4ced61","type":"TRIGGER","name":"TRG_AWH_CONFM_VM_UND_CO_TS","schemaName":"AWH_MAIN","sxml":""}