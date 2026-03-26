-- liquibase formatted sql
-- changeset AM_MAIN:1774556568048 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_kritikalitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_kritikalitaet.sql:null:3b7586ffcbfbb61a08ec15e72736a84c8a941fc1:create

grant select on am_main.hwas_kritikalitaet to am_apex;

