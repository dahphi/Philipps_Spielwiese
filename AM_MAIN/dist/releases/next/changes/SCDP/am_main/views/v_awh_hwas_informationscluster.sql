-- liquibase formatted sql
-- changeset AM_MAIN:1774556574109 stripComments:false logicalFilePath:SCDP/am_main/views/v_awh_hwas_informationscluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_informationscluster.sql:null:c4ab9b3c93c82204ffa0773d6c7a50e8fef2241b:create

create or replace force editionable view am_main.v_awh_hwas_informationscluster (
    incl_uid,
    incl_bezeichnung,
    incl_beschreibung,
    vet_lfd_nr,
    vef_lfd_nr,
    int_lfd_nr,
    aut_lfd_nr,
    inserted,
    updated,
    inserted_by,
    updated_by,
    dom_uid_fk
) as
    select
        incl_uid,
        incl_bezeichnung,
        incl_beschreibung,
        vet_lfd_nr,
        vef_lfd_nr,
        int_lfd_nr,
        aut_lfd_nr,
        inserted,
        updated,
        inserted_by,
        updated_by,
        dom_uid_fk
    from
        hwas_informationscluster;

