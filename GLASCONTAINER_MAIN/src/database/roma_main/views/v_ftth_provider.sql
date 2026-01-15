create or replace force editionable view v_ftth_provider (
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


-- sqlcl_snapshot {"hash":"e5ddd4237c59bc7b21335753b1cdaf1723fe1239","type":"VIEW","name":"V_FTTH_PROVIDER","schemaName":"ROMA_MAIN","sxml":""}