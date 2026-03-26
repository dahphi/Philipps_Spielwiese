create or replace force editionable view am_main.v_awh_hwas_anlagenkategorie_e3 (
    ak3_uid,
    ak3_beschreibung,
    ak3_bemessungskriterium,
    ak3_schwellwert,
    be2_uid,
    ak3_nummer,
    ak3_nc_implementierung,
    ak3_nc_bezeichnung,
    ak3_definition,
    inserted,
    updated,
    inserted_by,
    updated_by
) as
    select
        ak3_uid,
        ak3_beschreibung,
        ak3_bemessungskriterium,
        ak3_schwellwert,
        be2_uid,
        ak3_nummer,
        ak3_nc_implementierung,
        ak3_nc_bezeichnung,
        ak3_definition,
        inserted,
        updated,
        inserted_by,
        updated_by
    from
        hwas_anlagenkategorie_e3;


-- sqlcl_snapshot {"hash":"96fe23104c4ea00e228655c7b81c0d31ff6986b8","type":"VIEW","name":"V_AWH_HWAS_ANLAGENKATEGORIE_E3","schemaName":"AM_MAIN","sxml":""}