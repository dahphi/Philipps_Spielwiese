-- liquibase formatted sql
-- changeset AM_MAIN:1774557122332 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.table.awh_erheb_1_fachbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.table.awh_erheb_1_fachbereich.sql:null:d88558c3f7548c42c1a873e0971a133eb5c33374:create

grant select on awh_main.awh_erheb_1_fachbereich to am_main;

