-- liquibase formatted sql
-- changeset AM_MAIN:1774556574049 stripComments:false logicalFilePath:SCDP/am_main/views/v_awh_hwas_funktionsklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_funktionsklasse.sql:null:b145c093c18b0e4b21ee49270b87f473b69ec78f:create

create or replace force editionable view am_main.v_awh_hwas_funktionsklasse (
    fkl_uid,
    fkl_bezeichnung,
    fkl_beschreibung,
    inserted,
    updated,
    inserted_by,
    updated_by,
    tkt_uid,
    fkl_kritis_relevant
) as
    select
        fkl_uid,
        fkl_bezeichnung,
        fkl_beschreibung,
        inserted,
        updated,
        inserted_by,
        updated_by,
        tkt_uid,
        fkl_kritis_relevant
    from
        hwas_funktionsklasse;

