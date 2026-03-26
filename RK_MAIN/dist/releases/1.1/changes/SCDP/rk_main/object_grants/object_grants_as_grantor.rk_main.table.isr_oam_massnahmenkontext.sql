-- liquibase formatted sql
-- changeset RK_MAIN:1774555709251 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkontext.sql:null:174da89fa11634056052398d3626c9cd9d10bb76:create

grant select on rk_main.isr_oam_massnahmenkontext to rk_apex;

grant read on rk_main.isr_oam_massnahmenkontext to rk_read;

