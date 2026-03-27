-- liquibase formatted sql
-- changeset AM_MAIN:1774600129070 stripComments:false logicalFilePath:am_main/am_main/views/v_awh_hwas_tk_technologie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_tk_technologie.sql:null:83036e9f319bf697b3a387dec05ded60fd7dd22a:create

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

