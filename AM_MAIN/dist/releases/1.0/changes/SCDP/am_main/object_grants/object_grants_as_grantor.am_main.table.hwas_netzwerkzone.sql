-- liquibase formatted sql
-- changeset AM_MAIN:1774556568073 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_netzwerkzone.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_netzwerkzone.sql:null:477554aa52303546d165f554666265a57d517eca:create

grant select on am_main.hwas_netzwerkzone to am_apex;

