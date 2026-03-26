-- liquibase formatted sql
-- changeset AM_MAIN:1774556574147 stripComments:false logicalFilePath:SCDP/am_main/views/v_awh_hwas_virtuelle_maschinen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_virtuelle_maschinen.sql:null:51eaeb3e81af4c908fbe8b4946d9235869591c2b:create

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

