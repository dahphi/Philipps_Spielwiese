-- liquibase formatted sql
-- changeset AM_MAIN:1774600121883 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_itwo_raum_import_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_itwo_raum_import_hist_dml.sql:null:cb4cdf106a905b286c8ec67d5d1ec6361970cf5d:create

create or replace package am_main.pck_itwo_raum_import_hist_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_RAUM_import_hist. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT ITWO_RAUM_import_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_raum_import_hist in out itwo_raum_import_hist%rowtype
    );

    procedure p_import_itwo_raum;

end pck_itwo_raum_import_hist_dml;
/

