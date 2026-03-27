-- liquibase formatted sql
-- changeset AM_MAIN:1774600101564 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertrag_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertrag_produkt.sql:null:4eeaa5b570ce18db61de8f34d6ee7498680ea144:create

grant select on am_main.hwas_vertrag_produkt to am_apex;

