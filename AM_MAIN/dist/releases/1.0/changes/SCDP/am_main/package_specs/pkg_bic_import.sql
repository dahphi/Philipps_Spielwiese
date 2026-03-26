-- liquibase formatted sql
-- changeset AM_MAIN:1774556572206 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pkg_bic_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pkg_bic_import.sql:null:4999c87182fb24d691ccd50da3b01ade7a6a6684:create

create or replace package am_main.pkg_bic_import as
    procedure prc_bic_modelle_to_import;

    procedure prc_sync_prozesstyp_from_import;

end pkg_bic_import;
/

