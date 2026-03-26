create or replace editionable trigger awh_main.trg_awh_erheb_1_fachbereich_ts before
    insert or update on awh_main.awh_erheb_1_fachbereich
    for each row
begin
    select
        sysdate
    into :new.erf_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erheb_1_fachbereich_ts enable;


-- sqlcl_snapshot {"hash":"75071270b978e1cea0192c843364f13f2086827f","type":"TRIGGER","name":"TRG_AWH_ERHEB_1_FACHBEREICH_TS","schemaName":"AWH_MAIN","sxml":""}