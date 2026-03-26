-- liquibase formatted sql
-- changeset AM_MAIN:1774556574095 stripComments:false logicalFilePath:SCDP/am_main/views/v_awh_hwas_geraeteverbund.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_geraeteverbund.sql:null:2f4435e2ea528cbcbbc47eab9c47d52dc8c374e1:create

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

