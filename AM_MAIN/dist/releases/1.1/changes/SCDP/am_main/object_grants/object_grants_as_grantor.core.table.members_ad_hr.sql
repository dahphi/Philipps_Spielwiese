-- liquibase formatted sql
-- changeset AM_MAIN:1774557122454 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.table.members_ad_hr.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.members_ad_hr.sql:null:38cb4af696e3689d614f7b7279d7151843399f2a:create

grant select on core.members_ad_hr to am_main;

grant read on core.members_ad_hr to am_main;

