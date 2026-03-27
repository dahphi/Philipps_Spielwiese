-- liquibase formatted sql
-- changeset AM_MAIN:1774600099616 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_bsi_grundschutz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_bsi_grundschutz.sql:null:4defec9f919a8908cff40c2c97977bacb867111e:create

grant execute on am_main.pck_bsi_grundschutz to am_apex;

