-- liquibase formatted sql
-- changeset AM_MAIN:1774600101042 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_produktbestandteil.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_produktbestandteil.sql:null:a7a587f0b34a247804e5a4c882a520b5d27e529e:create

grant select on am_main.hwas_produktbestandteil to am_apex;

grant select on am_main.hwas_produktbestandteil to awh_apex;

