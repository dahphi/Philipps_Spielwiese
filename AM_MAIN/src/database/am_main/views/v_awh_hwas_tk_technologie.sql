create or replace force editionable view am_main.v_awh_hwas_tk_technologie (
    tkt_uid,
    tkt_bezeichnung,
    tkt_highlights,
    ak3_uid,
    inserted,
    updated,
    inserted_by,
    updated_by,
    tkt_lebenszyklus_status
) as
    select
        tkt_uid,
        tkt_bezeichnung,
        tkt_highlights,
        ak3_uid,
        inserted,
        updated,
        inserted_by,
        updated_by,
        tkt_lebenszyklus_status
    from
        hwas_tk_technologie;


-- sqlcl_snapshot {"hash":"83036e9f319bf697b3a387dec05ded60fd7dd22a","type":"VIEW","name":"V_AWH_HWAS_TK_TECHNOLOGIE","schemaName":"AM_MAIN","sxml":""}