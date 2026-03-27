-- liquibase formatted sql
-- changeset AM_MAIN:1774600101505 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertrag.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertrag.sql:null:e2e8f30fa8f80fbc56e2d35af179c60231c2671b:create

grant select on am_main.hwas_vertrag to am_apex;

grant select on am_main.hwas_vertrag to awh_apex;

