create or replace force editionable view am_main.v_awh_hwas_geraeteverbund (
    gvb_uid,
    gvb_bezeichnung,
    gvb_san,
    inserted,
    updated,
    inserted_by,
    updated_by,
    gvb_verbundtyp,
    typ_uid
) as
    select
        gvb_uid,
        gvb_bezeichnung,
        gvb_san,
        inserted,
        updated,
        inserted_by,
        updated_by,
        gvb_verbundtyp,
        typ_uid
    from
        hwas_geraeteverbund;


-- sqlcl_snapshot {"hash":"2f4435e2ea528cbcbbc47eab9c47d52dc8c374e1","type":"VIEW","name":"V_AWH_HWAS_GERAETEVERBUND","schemaName":"AM_MAIN","sxml":""}