-- liquibase formatted sql
-- changeset AM_MAIN:1774600128617 stripComments:false logicalFilePath:am_main/am_main/views/v_awh_hwas_bereich_e2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_bereich_e2.sql:null:3e32292ca79f18630c7468b34070066536f103dd:create

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

