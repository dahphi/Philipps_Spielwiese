-- liquibase formatted sql
-- changeset AM_MAIN:1774557115723 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_vertragsmanagement.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_vertragsmanagement.sql:null:0265919ea1c3e8ef37551bd3c232e7aad8766cdc:create

grant execute on am_main.pck_hwas_vertragsmanagement to am_apex;

grant execute on am_main.pck_hwas_vertragsmanagement to awh_apex;

