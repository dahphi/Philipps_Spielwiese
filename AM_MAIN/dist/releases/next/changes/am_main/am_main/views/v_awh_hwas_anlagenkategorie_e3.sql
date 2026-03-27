-- liquibase formatted sql
-- changeset AM_MAIN:1774600128570 stripComments:false logicalFilePath:am_main/am_main/views/v_awh_hwas_anlagenkategorie_e3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_anlagenkategorie_e3.sql:null:96fe23104c4ea00e228655c7b81c0d31ff6986b8:create

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

