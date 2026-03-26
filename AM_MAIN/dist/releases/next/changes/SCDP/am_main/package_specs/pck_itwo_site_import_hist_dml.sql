-- liquibase formatted sql
-- changeset AM_MAIN:1774556572199 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_itwo_site_import_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_itwo_site_import_hist_dml.sql:null:807bef9280c478dbb1b3b1eb96f6b8cd08248cb1:create

create or replace package am_main.pck_itwo_site_import_hist_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_SITE_import_hist. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT ITWO_SITE_import_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_site_import_hist in out itwo_site_import_hist%rowtype
    );

    procedure p_import_itwo_site;

end pck_itwo_site_import_hist_dml;
/

