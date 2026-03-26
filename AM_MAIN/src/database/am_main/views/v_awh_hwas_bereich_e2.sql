create or replace force editionable view am_main.v_awh_hwas_bereich_e2 (
    be2_uid,
    be2_bezeichnung,
    be2_nummer,
    kd1_uid,
    inserted,
    updated,
    inserted_by,
    updated_by
) as
    select
        be2_uid,
        be2_bezeichnung,
        be2_nummer,
        kd1_uid,
        inserted,
        updated,
        inserted_by,
        updated_by
    from
        hwas_bereich_e2;


-- sqlcl_snapshot {"hash":"3e32292ca79f18630c7468b34070066536f103dd","type":"VIEW","name":"V_AWH_HWAS_BEREICH_E2","schemaName":"AM_MAIN","sxml":""}