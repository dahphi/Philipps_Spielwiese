create or replace force editionable view roma_main.v_ftth_provider (
    r,
    d1,
    d_siebel
) as
    select
        pv_key2 as r,
        v_wert1 as d1,
        v_wert2 as d_siebel
    from
        params
    where
        pv_key1 = 'FTTH_PROVIDER';


-- sqlcl_snapshot {"hash":"b6a487caca324d089c72ea3cef20c9988fe8f9a8","type":"VIEW","name":"V_FTTH_PROVIDER","schemaName":"ROMA_MAIN","sxml":""}