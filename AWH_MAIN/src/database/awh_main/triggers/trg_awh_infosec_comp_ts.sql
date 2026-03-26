create or replace editionable trigger awh_main.trg_awh_infosec_comp_ts before
    insert or update on awh_main.awh_infosec_comp
    for each row
begin
    select
        sysdate
    into :new.cop_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_infosec_comp_ts enable;


-- sqlcl_snapshot {"hash":"620774aa2a15b176167b373b573f0b2873463343","type":"TRIGGER","name":"TRG_AWH_INFOSEC_COMP_TS","schemaName":"AWH_MAIN","sxml":""}