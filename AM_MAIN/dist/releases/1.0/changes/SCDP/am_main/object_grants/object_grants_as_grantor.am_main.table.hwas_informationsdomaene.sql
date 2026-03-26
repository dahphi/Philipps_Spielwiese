-- liquibase formatted sql
-- changeset AM_MAIN:1774556568032 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_informationsdomaene.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_informationsdomaene.sql:null:a00815dc37ec428f069f03aab02bc0b12b15bedf:create

grant select on am_main.hwas_informationsdomaene to am_apex;

grant select on am_main.hwas_informationsdomaene to awh_apex;

grant read on am_main.hwas_informationsdomaene to awh_read_jira;

