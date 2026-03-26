-- liquibase formatted sql
-- changeset AM_MAIN:1774556568070 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_netzebene.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_netzebene.sql:null:c1fb82ea2b18bff43658f023938af1ebaf8ca351:create

grant select on am_main.hwas_netzebene to am_apex;

