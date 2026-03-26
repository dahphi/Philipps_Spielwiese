create or replace editionable trigger awh_main.trg_awh_erhebungsbogen_9_dfa_ts before
    insert or update on awh_main.awh_erhebungsbogen_9_dfa
    for each row
begin
    select
        sysdate
    into :new.e9d_timestamp
    from
        dual;

end;
/

alter trigger awh_main.trg_awh_erhebungsbogen_9_dfa_ts enable;


-- sqlcl_snapshot {"hash":"f84ad10132fefb9e1402cd5fe8d6b479b2a95520","type":"TRIGGER","name":"TRG_AWH_ERHEBUNGSBOGEN_9_DFA_TS","schemaName":"AWH_MAIN","sxml":""}