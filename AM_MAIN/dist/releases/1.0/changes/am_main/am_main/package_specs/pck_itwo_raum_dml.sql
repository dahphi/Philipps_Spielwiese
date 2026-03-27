-- liquibase formatted sql
-- changeset AM_MAIN:1774600121851 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_itwo_raum_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_itwo_raum_dml.sql:null:2f7ae301889415355818b82135768b184e8e58a3:create

create or replace package am_main.pck_itwo_raum_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_RAUM. Return PK.
*
* @param       pior_isr_oam_raum  IN OUT ITWO_RAUM%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_raum in out itwo_raum%rowtype
    );

    procedure p_update (
        pior_itwo_raum in out itwo_raum%rowtype
    );

end pck_itwo_raum_dml;
/

