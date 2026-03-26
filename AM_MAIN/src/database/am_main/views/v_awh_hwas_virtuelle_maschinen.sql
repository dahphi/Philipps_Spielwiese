create or replace force editionable view am_main.v_awh_hwas_virtuelle_maschinen (
    vm_uid,
    vm_bezeichnung,
    vm_host,
    vm_san,
    inserted,
    updated,
    inserted_by,
    updated_by,
    vm_link_wiki,
    vm_beschreibung
) as
    select
        vm_uid,
        vm_bezeichnung,
        vm_host,
        vm_san,
        inserted,
        updated,
        inserted_by,
        updated_by,
        vm_link_wiki,
        vm_beschreibung
    from
        hwas_virtuelle_maschinen;


-- sqlcl_snapshot {"hash":"51eaeb3e81af4c908fbe8b4946d9235869591c2b","type":"VIEW","name":"V_AWH_HWAS_VIRTUELLE_MASCHINEN","schemaName":"AM_MAIN","sxml":""}