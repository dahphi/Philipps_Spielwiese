create or replace force editionable view am_main.v_awh_hwas_krit_dienstlstg_e1 (
    kd1_uid,
    kd1_bezeichnung,
    kd1_nummer,
    inserted,
    updated,
    inserted_by,
    updated_by,
    kd1_link
) as
    select
        kd1_uid,
        kd1_bezeichnung,
        kd1_nummer,
        inserted,
        updated,
        inserted_by,
        updated_by,
        kd1_link
    from
        hwas_krit_dienstlstg_e1;


-- sqlcl_snapshot {"hash":"0c329c8702de6c1db0c29540c1349b891a379f37","type":"VIEW","name":"V_AWH_HWAS_KRIT_DIENSTLSTG_E1","schemaName":"AM_MAIN","sxml":""}