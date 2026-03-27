-- liquibase formatted sql
-- changeset AM_MAIN:1774600100901 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_lieferant_vertragsdetail.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_lieferant_vertragsdetail.sql:null:774c7cbb158b80312cf6bc008b79366ef45faa6a:create

grant select on am_main.hwas_lieferant_vertragsdetail to am_apex;

