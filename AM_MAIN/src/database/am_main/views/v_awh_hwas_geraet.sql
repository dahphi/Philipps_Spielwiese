create or replace force editionable view am_main.v_awh_hwas_geraet (
    grt_uid,
    grt_inventartnr,
    mdl_uid,
    grt_assetname,
    grt_herstell_inbetrnhm_jahr,
    rm_uid,
    inserted,
    updated,
    inserted_by,
    updated_by,
    grt_link_fremdsystem,
    grt_zielsystem,
    geb_uid,
    hst_uid,
    grt_data_custodian,
    quellsystem_id,
    grt_quellsystem,
    gvb_uid,
    fkl_uid
) as
    select
        grt.grt_uid,
        grt.grt_inventartnr,
        grt.mdl_uid,
        grt.grt_assetname,
        grt.grt_herstell_inbetrnhm_jahr,
        rm.rm_uid,
        grt.inserted,
        grt.updated,
        grt.inserted_by,
        grt.updated_by,
        grt.grt_link_fremdsystem,
        grt.grt_zielsystem,
        rm.geb_uid,
        grt.hst_uid,
        grt.grt_data_custodian,
        grt.quellsystem_id,
        grt.grt_quellsystem,
        grt.gvb_uid,
        grt.fkl_uid
    from
        hwas_geraet grt
        left outer join hwas_raum   rm on grt.rm_uid = rm.rm_uid;


-- sqlcl_snapshot {"hash":"880ef0b9a295fa1b83f7ba0c30cf8a827b5f2177","type":"VIEW","name":"V_AWH_HWAS_GERAET","schemaName":"AM_MAIN","sxml":""}