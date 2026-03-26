-- liquibase formatted sql
-- changeset RK_MAIN:1774561789386 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkontext.sql:76d7908504bc5341108a40da52e626d01cbfc698:174da89fa11634056052398d3626c9cd9d10bb76:alter

grant select on rk_main.isr_oam_massnahmenkontext to rk_apex;

