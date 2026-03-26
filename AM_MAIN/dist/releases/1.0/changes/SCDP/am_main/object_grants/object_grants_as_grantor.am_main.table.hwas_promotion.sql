-- liquibase formatted sql
-- changeset AM_MAIN:1774556568088 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_promotion.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_promotion.sql:null:8b93dcfae4119d596916f151a648906b5e774055:create

grant select on am_main.hwas_promotion to am_apex;

