-- liquibase formatted sql
-- changeset AM_MAIN:1774556568067 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_netz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_netz.sql:null:65d94d9adf2a53a7ee00c3a64c223860f3be5eb4:create

grant select on am_main.hwas_netz to am_apex;

