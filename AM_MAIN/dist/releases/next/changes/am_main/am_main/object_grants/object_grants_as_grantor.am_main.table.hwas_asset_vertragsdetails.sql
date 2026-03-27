-- liquibase formatted sql
-- changeset AM_MAIN:1774600100037 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_asset_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_asset_vertragsdetails.sql:null:31204938257fa21ac9354e53ee13554e484954c1:create

grant select on am_main.hwas_asset_vertragsdetails to am_apex;

grant select on am_main.hwas_asset_vertragsdetails to awh_apex;

