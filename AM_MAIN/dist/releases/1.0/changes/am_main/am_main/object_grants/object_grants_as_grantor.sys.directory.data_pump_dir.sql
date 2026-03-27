-- liquibase formatted sql
-- changeset AM_MAIN:1774600129755 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.sys.directory.data_pump_dir.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/sys/object_grants/object_grants_as_grantor.sys.directory.data_pump_dir.sql:null:eafa3d3a61df86ac35ef8baf4d0e5b109072f95c:create

grant execute on directory sys.data_pump_dir to am_main;

grant read on directory sys.data_pump_dir to am_main;

grant write on directory sys.data_pump_dir to am_main;

