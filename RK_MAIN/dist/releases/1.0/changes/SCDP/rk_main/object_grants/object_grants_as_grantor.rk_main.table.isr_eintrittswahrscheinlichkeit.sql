-- liquibase formatted sql
-- changeset RK_MAIN:1774561690604 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_eintrittswahrscheinlichkeit.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_eintrittswahrscheinlichkeit.sql:null:cb92f7734ab61356e80aefaa5333f844c4f3840f:create

grant select on rk_main.isr_eintrittswahrscheinlichkeit to rk_apex;

grant read on rk_main.isr_eintrittswahrscheinlichkeit to rk_read;

