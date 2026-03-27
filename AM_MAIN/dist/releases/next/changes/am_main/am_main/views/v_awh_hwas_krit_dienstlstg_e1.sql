-- liquibase formatted sql
-- changeset AM_MAIN:1774600129024 stripComments:false logicalFilePath:am_main/am_main/views/v_awh_hwas_krit_dienstlstg_e1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_krit_dienstlstg_e1.sql:null:0c329c8702de6c1db0c29540c1349b891a379f37:create

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

